import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learningdart/blocs/comment_bloc.dart';
import 'package:learningdart/blocs/profile_bloc.dart';
import 'package:learningdart/pages/profile_page.dart';

class CommentSheet extends StatefulWidget {
  final String postId;

  const CommentSheet({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentSheetState createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final supabase = Supabase.instance.client;
  String? _currentUserProfilePic;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserProfilePic();
    context.read<CommentBloc>().add(LoadComments(widget.postId));
  }

  Future<void> _loadCurrentUserProfilePic() async {
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId != null) {
      final profileData = await supabase
          .from('Profile')
          .select('pfp_image')
          .eq('user_id', currentUserId)
          .single();
      if (mounted) {
        setState(() {
          _currentUserProfilePic = profileData['pfp_image'];
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Comments List
              Expanded(
                child: BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, state) {
                    if (state is CommentLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is CommentError) {
                      return Center(child: Text(state.message));
                    } else if (state is CommentLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                      
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) {
                          final comment = state.comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(comment['profile']['pfp_image'] ?? ''),
                            ),
                            title: GestureDetector(
                              onTap: () async {
                                // Get the user's profile data
                                final profileData = await supabase
                                    .from('Profile')
                                    .select('user_id, profile_id')
                                    .eq('profile_id', comment['profile_id'])
                                    .single();

                                // Check if this is the current user
                                final currentUserId = supabase.auth.currentUser?.id;
                                final isCurrentUser = currentUserId == profileData['user_id'];

                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => ProfileBloc(),
                                        child: ProfilePage(
                                          userId: profileData['user_id'],
                                          profileId: profileData['profile_id'],
                                          username: comment['profile']['username'],
                                          isCurrentUser: isCurrentUser,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                comment['profile']['username'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              comment['comment'],
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        },
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
              // Comment Input
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_currentUserProfilePic ?? ''),
                      radius: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            context.read<CommentBloc>().add(AddComment(widget.postId, value));
                            _commentController.clear();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          context.read<CommentBloc>().add(AddComment(widget.postId, _commentController.text));
                          _commentController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 