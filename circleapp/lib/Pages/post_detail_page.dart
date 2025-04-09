import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learningdart/Pages/profile_page.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];
  bool isLiked = false;
  int likeCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPostDetails();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> loadPostDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get current user ID
      final currentUserId = supabase.auth.currentUser?.id;
      
      // Check if post is liked by current user
      if (currentUserId != null) {
        final likeData = await supabase
            .from('Likes')
            .select()
            .eq('post_id', widget.post['id'])
            .eq('user_id', currentUserId)
            .maybeSingle();
        
        setState(() {
          isLiked = likeData != null;
        });
      }

      // Get like count
      final likesData = await supabase
          .from('Post')
          .select('likes')
          .eq('id', widget.post['id'])
          .single();
      
      // Load comments
      final commentsData = await supabase
          .from('Comments')
          .select('''
            *,
            Profile:profile_id (
              profile_id,
              pfp_image,
              User:user_id (
                username
              )
            )
          ''')
          .eq('post_id', widget.post['id'])
          .order('created_at', ascending: false);

      setState(() {
        likeCount = likesData['likes'] ?? 0;
        comments = List<Map<String, dynamic>>.from(commentsData);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading post details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> toggleLike() async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) return;

      // Get current user's profile_id
      final profileData = await supabase
          .from('Profile')
          .select('profile_id')
          .eq('user_id', currentUserId)
          .single();
      
      final profileId = profileData['profile_id'];

      if (isLiked) {
        // Unlike post
        await supabase
            .from('Likes')
            .delete()
            .eq('post_id', widget.post['id'])
            .eq('user_id', currentUserId);
        
        // Decrement like count
        await supabase
            .from('Post')
            .update({'likes': likeCount - 1})
            .eq('id', widget.post['id']);
        
        setState(() {
          isLiked = false;
          likeCount--;
        });
      } else {
        // Like post
        await supabase.from('Likes').insert({
          'post_id': widget.post['id'],
          'user_id': currentUserId,
          'profile_id': profileId,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        // Increment like count
        await supabase
            .from('Post')
            .update({'likes': likeCount + 1})
            .eq('id', widget.post['id']);
        
        // Create notification for post owner
        if (widget.post['profile_id'] != null && currentUserId != null && widget.post['user_id'] != currentUserId) {
          await supabase.from('Notifications').insert({
            'recipient_id': widget.post['profile_id'],
            'sender_id': currentUserId,
            'type': 'like',
            'post_id': widget.post['id'],
            'created_at': DateTime.now().toIso8601String(),
            'is_read': false
          });
        }
        
        setState(() {
          isLiked = true;
          likeCount++;
        });
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) return;

      // Get current user's profile_id
      final profileData = await supabase
          .from('Profile')
          .select('profile_id')
          .eq('user_id', currentUserId)
          .single();
      
      final profileId = profileData['profile_id'];

      // Add comment
      final newComment = await supabase.from('Comments').insert({
        'post_id': widget.post['id'],
        'user_id': currentUserId,
        'profile_id': profileId,
        'content': _commentController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      }).select('''
        *,
        Profile:profile_id (
          profile_id,
          pfp_image,
          User:user_id (
            username
          )
        )
      ''').single();

      // Increment comment count
      await supabase
          .from('Post')
          .update({'comments': (widget.post['comments'] ?? 0) + 1})
          .eq('id', widget.post['id']);
      
      // Create notification for post owner
      if (widget.post['user_id'] != currentUserId) {
        await supabase.from('Notifications').insert({
          'recipient_id': widget.post['profile_id'],
          'sender_id': profileId,
          'type': 'comment',
          'created_at': DateTime.now().toIso8601String(),
          'is_read': false
        });
      }

      setState(() {
        comments.insert(0, newComment);
        _commentController.clear();
      });
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final postOwner = widget.post['Profile'];
    final username = postOwner?['User']?['username'] ?? 'Unknown User';
    final pfpImage = postOwner?['pfp_image'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Post',
          style: GoogleFonts.daysOne(
            color: Color.fromRGBO(117, 216, 216, 1),
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Post header with user info
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                userId: widget.post['user_id'],
                                profileId: widget.post['profile_id'],
                                username: username,
                                isCurrentUser: supabase.auth.currentUser?.id == widget.post['user_id'],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: pfpImage != null
                              ? NetworkImage(pfpImage)
                              : AssetImage('assets/Images/defaultpfp.jpg') as ImageProvider,
                          radius: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Post image
                if (widget.post['image_path'] != null)
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.post['image_path']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                
                // Like, comment buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 28,
                        ),
                        onPressed: toggleLike,
                      ),
                      Text(
                        '$likeCount likes',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.comment_outlined, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '${comments.length} comments',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                
                // Caption
                if (widget.post['caption'] != null && widget.post['caption'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$username ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.post['caption'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                Divider(color: Colors.grey[800]),
                
                // Comments section
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final commentProfile = comment['Profile'];
                      final commentUsername = commentProfile?['User']?['username'] ?? 'Unknown';
                      final commentPfp = commentProfile?['pfp_image'];
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: commentPfp != null
                                  ? NetworkImage(commentPfp)
                                  : AssetImage('assets/Images/defaultpfp.jpg') as ImageProvider,
                              radius: 16,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '$commentUsername ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: comment['content'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _formatTimestamp(comment['created_at']),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Comment input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: Colors.grey[900],
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Color.fromRGBO(117, 216, 216, 1)),
                        onPressed: addComment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
  
  String _formatTimestamp(String timestamp) {
    final now = DateTime.now();
    final commentTime = DateTime.parse(timestamp);
    final difference = now.difference(commentTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return '${commentTime.day}/${commentTime.month}/${commentTime.year}';
    }
  }
} 