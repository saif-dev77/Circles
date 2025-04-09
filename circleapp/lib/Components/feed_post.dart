import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learningdart/blocs/comment_bloc.dart';
import 'package:learningdart/Components/comment_sheet.dart';

class FeedPost extends StatefulWidget {
  final String postimage;
  final String username;
  final String profileimage;
  final String caption;
  final int no_of_likes;
  final int no_of_comments;
  final String post_id;

  const FeedPost({super.key, required this.caption, required this.postimage, required this.profileimage, required this.username, required this.no_of_comments, required this.no_of_likes, required this.post_id});

  @override
  _FeedPostState createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> with SingleTickerProviderStateMixin {
  bool isLiked = false;
  bool isProcessing = false;
  Timer? _debounceTimer;
  late int likeCount;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _bounceAnimation;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    likeCount = widget.no_of_likes;
    
    // Check if user has already liked this post
    _checkIfAlreadyLiked();
    
    // Initialize the controller first
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Initialize color animation
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Color.fromRGBO(117, 216, 216, 1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Initialize size animation
    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 30, end: 45)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 45, end: 30)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 60,
      ),
    ]).animate(_controller);

    // Initialize bounce animation
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    // Add status listener
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isLiked = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isLiked = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    _debounceTimer?.cancel();

    if (isProcessing) return;

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        if (widget.post_id == null || widget.post_id.isEmpty) {
          print('Error: post_id is null or empty');
          return;
        }

        setState(() {
          isProcessing = true;
        });

        // Get current user's ID and profile ID
        final currentUserId = supabase.auth.currentUser?.id;
        if (currentUserId == null) {
          print('Error: User not authenticated');
          return;
        }

        // Get user's profile ID
        final profileData = await supabase
            .from('Profile')
            .select('profile_id, user_id')
            .eq('user_id', currentUserId)
            .single();
        
        final currentUserProfileId = profileData['profile_id'];

        // Get post data including likes_array
        final postData = await supabase
            .from('Post')
            .select('profile_id, user_id, likes_array')
            .eq('post_id', widget.post_id)
            .single();
        
        final postOwnerProfileId = postData['profile_id'];
        final postOwnerId = postData['user_id'];
        List<dynamic> likesArray = postData['likes_array'] ?? [];
        
        bool alreadyLiked = likesArray.contains(currentUserProfileId);
        
        if (alreadyLiked) {
          // Remove profile_id from likes_array
          likesArray.remove(currentUserProfileId);
          
          await supabase
              .from('Post')
              .update({
                'likes_array': likesArray,
                'likes': likesArray.length  // Update like count
              })
              .eq('post_id', widget.post_id);
          
          if (mounted) {
            setState(() {
              likeCount = likesArray.length;
              isLiked = false;
            });
          }
          _controller.reverse();
        } else {
          // Add profile_id to likes_array
          likesArray.add(currentUserProfileId);
          
          await supabase
              .from('Post')
              .update({
                'likes_array': likesArray,
                'likes': likesArray.length  // Update like count
              })
              .eq('post_id', widget.post_id);
          
          // Create notification if not liking your own post
          if (currentUserId != postOwnerId) {
            print('Creating like notification');
            try {
              await supabase
                  .from('Notifications')
                  .insert({
                    'recipient_id': postOwnerProfileId,
                    'sender_id': currentUserProfileId,
                    'type': 'like',
                    'post_id': widget.post_id,
                    'created_at': DateTime.now().toIso8601String(),
                    'is_read': false
                  });
              print('Like notification created successfully');
            } catch (notifError) {
              print('Error creating notification: $notifError');
            }
          }
          
          if (mounted) {
            setState(() {
              likeCount = likesArray.length;
              isLiked = true;
            });
          }
          _controller.forward();
        }
      } catch (e) {
        print('Error updating likes: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update like')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isProcessing = false;
          });
        }
      }
    });
  }

  Future<void> _checkIfAlreadyLiked() async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) return;

      // Get current user's profile ID
      final profileData = await supabase
          .from('Profile')
          .select('profile_id')
          .eq('user_id', currentUserId)
          .single();
      
      final currentUserProfileId = profileData['profile_id'];

      // Check if the post has a likes_array field and if the user's profile ID is in it
      final postData = await supabase
          .from('Post')
          .select('likes_array')
          .eq('post_id', widget.post_id)
          .single();

      if (postData['likes_array'] != null) {
        // Using likes_array approach
        List<dynamic> likesArray = postData['likes_array'] ?? [];
        bool alreadyLiked = likesArray.contains(currentUserProfileId);
        
        if (mounted) {
          setState(() {
            isLiked = alreadyLiked;
            if (isLiked) {
              _controller.value = 1.0; // Set controller to completed state
            }
          });
        }
      } else {
        // Fallback to Likes table approach
        final likeData = await supabase
            .from('Likes')
            .select()
            .eq('post_id', widget.post_id)
            .eq('user_id', currentUserId)
            .maybeSingle();
        
        if (mounted) {
          setState(() {
            isLiked = likeData != null;
            if (isLiked) {
              _controller.value = 1.0; // Set controller to completed state
            }
          });
        }
      }
    } catch (e) {
      print('Error checking if post is already liked: $e');
    }
  }

  Row buildLikeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => BlocProvider(
                    create: (context) => CommentBloc(),
                    child: CommentSheet(postId: widget.post_id),
                  ),
                );
              },
              child: SizedBox(
                child: Icon(Icons.comment, color: Colors.white, size: 30),
              ),
            ),
            Text(
              '${widget.no_of_comments} comments',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),

        Column(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, _) {
                return Transform.scale(
                  scale: _bounceAnimation.value,
                  child: IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_outline,
                      color: _colorAnimation.value,
                      size: _sizeAnimation.value,
                    ),
                    onPressed: isProcessing ? null : _toggleLike,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                );
              },
            ),
            Text(
              '$likeCount likes',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),

        SizedBox(
          child: Icon(Icons.bookmark_add_outlined, color: Colors.white, size: 30),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            SizedBox(
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.profileimage),
                radius: 20,
              ),
            ),

            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 7, bottom: 12),
                child: Text(widget.username,
                style: GoogleFonts.daysOne(color: Colors.white, fontSize: 14),),
              ),
            ),
          Spacer(),
            SizedBox(
              child: Icon(Icons.more_vert, color: Colors.white,),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        

      
        Container(
          
          height: 420,
          width: 420,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.postimage),
              fit: BoxFit.fitWidth
            ),
          ),
        ),
      Divider(
          color: Colors.grey,
        ),

        SizedBox(
          height: 10,
        ),
        buildLikeRow(),

        SizedBox(
          height: 5,
        ),

      Row(
        children: [
          SizedBox(
            child: Text(widget.username, style: GoogleFonts.daysOne(color: Colors.white),),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            child: Padding(padding: EdgeInsets.only(top: 0),
            child: SizedBox(
            child: Text(widget.caption, style: TextStyle(color: Colors.white),),
          ),),
          ),
        ],
      ),
      SizedBox(
        height: 25,
      ),
      ],
    );
  }
}