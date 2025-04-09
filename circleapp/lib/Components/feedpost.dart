Future<void> toggleLike() async {
  try {
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) return;

    // Get current user's profile_id
    final currentUserProfileData = await supabase
        .from('Profile')
        .select('profile_id')
        .eq('user_id', currentUserId)
        .single();
    
    final currentUserProfileId = currentUserProfileData['profile_id'];

    if (isLiked) {
      // Unlike post
      await supabase
          .from('Likes')
          .delete()
          .eq('post_id', widget.post['post_id'])
          .eq('user_id', currentUserId);
      
      // Decrement like count
      await supabase
          .from('Post')
          .update({'likes': likeCount - 1})
          .eq('post_id', widget.post['post_id']);
      
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      // Like post
      await supabase.from('Likes').insert({
        'post_id': widget.post['post_id'],
        'user_id': currentUserId,
        'profile_id': currentUserProfileId,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Increment like count
      await supabase
          .from('Post')
          .update({'likes': likeCount + 1})
          .eq('post_id', widget.post['post_id']);
      
      // Create notification for post owner (only if it's not the current user's post)
      final postOwnerId = widget.post['profile_id'];
      if (postOwnerId != currentUserProfileId) {
        print('Creating like notification');
        await supabase.from('Notifications').insert({
          'recipient_id': postOwnerId,
          'sender_id': currentUserProfileId,
          'type': 'like',
          'post_id': widget.post['post_id'],
          'created_at': DateTime.now().toIso8601String(),
          'is_read': false
        });
        print('Like notification created successfully');
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