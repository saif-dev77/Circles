import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Events
abstract class CommentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadComments extends CommentEvent {
  final String postId;
  
  LoadComments(this.postId);
  
  @override
  List<Object?> get props => [postId];
}

class AddComment extends CommentEvent {
  final String postId;
  final String comment;
  
  AddComment(this.postId, this.comment);
  
  @override
  List<Object?> get props => [postId, comment];
}

// States
abstract class CommentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Map<String, dynamic>> comments;
  
  CommentLoaded(this.comments);
  
  @override
  List<Object?> get props => [comments];
}

class CommentError extends CommentState {
  final String message;
  
  CommentError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final supabase = Supabase.instance.client;
  
  CommentBloc() : super(CommentLoading()) {
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
  }
  
  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit
  ) async {
    emit(CommentLoading());
    
    try {
      final response = await supabase
          .from('Post')
          .select('comments_array')
          .eq('post_id', event.postId)
          .single();
          
      final commentsArray = (response['comments_array'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      
      // Fetch comment details for each comment
      final comments = await Future.wait(
        commentsArray.map((comment) async {
          final profileData = await supabase
              .from('Profile')
              .select('pfp_image, user_id, User:user_id(username)')
              .eq('profile_id', comment['profile_id'])
              .single();
              
          return {
            'profile_id': comment['profile_id'],
            'comment': comment['comment'],
            'created_at': comment['created_at'],
            'profile': {
              'pfp_image': profileData['pfp_image'],
              'username': profileData['User']['username'],
            }
          };
        })
      );
      
      emit(CommentLoaded(comments));
    } catch (e) {
      print('Error loading comments: $e');
      emit(CommentError('Error loading comments: $e'));
    }
  }
  
  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentState> emit
  ) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        emit(CommentError('User not authenticated'));
        return;
      }
      
      // Get current user's profile ID
      final profileData = await supabase
          .from('Profile')
          .select('profile_id')
          .eq('user_id', currentUserId)
          .single();
          
      final currentUserProfileId = profileData['profile_id'];
      
      // Get post data
      final postData = await supabase
          .from('Post')
          .select('profile_id, user_id, comments_array')
          .eq('post_id', event.postId)
          .single();
          
      final postOwnerProfileId = postData['profile_id'];
      final postOwnerId = postData['user_id'];
      List<dynamic> commentsArray = postData['comments_array'] ?? [];
      
      // Add new comment
      final newComment = {
        'profile_id': currentUserProfileId,
        'comment': event.comment,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      commentsArray.add(newComment);
      
      // Update post with new comment and update comments count
      await supabase
          .from('Post')
          .update({
            'comments_array': commentsArray,
            'comments': commentsArray.length  // Update the comments count
          })
          .eq('post_id', event.postId);
          
      // Create notification if not commenting on own post
      if (currentUserId != postOwnerId) {
        await supabase
            .from('Notifications')
            .insert({
              'recipient_id': postOwnerProfileId,
              'sender_id': currentUserProfileId,
              'type': 'comment',
              'post_id': event.postId,
              'created_at': DateTime.now().toIso8601String(),
              'is_read': false
            });
      }
      
      // Reload comments
      add(LoadComments(event.postId));
    } catch (e) {
      print('Error adding comment: $e');
      emit(CommentError('Error adding comment: $e'));
    }
  }
} 