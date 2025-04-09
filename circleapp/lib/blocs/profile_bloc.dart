import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;
  final String profileId;
  final bool isCurrentUser;

  LoadProfile({required this.userId, required this.profileId, required this.isCurrentUser});

  @override
  List<Object?> get props => [userId, profileId, isCurrentUser];
}

class FollowUser extends ProfileEvent {
  final String targetUserId;
  final String targetProfileId;

  FollowUser({required this.targetUserId, required this.targetProfileId});

  @override
  List<Object?> get props => [targetUserId, targetProfileId];
}

class UnfollowUser extends ProfileEvent {
  final String targetUserId;
  final String targetProfileId;

  UnfollowUser({required this.targetUserId, required this.targetProfileId});

  @override
  List<Object?> get props => [targetUserId, targetProfileId];
}

// States
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userId;
  final String profileId;
  final String username;
  final String? profileImageUrl;
  final String? bio;
  final int followers;
  final int following;
  final List<Map<String, dynamic>> posts;
  final bool isCurrentUser;
  final bool isFollowing;
  final bool canViewPosts;
  final bool isFollowActionInProgress;

  ProfileLoaded({
    required this.userId,
    required this.profileId,
    required this.username,
    this.profileImageUrl,
    this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.canViewPosts,
    this.isFollowActionInProgress = false,
  });

  @override
  List<Object?> get props => [
    userId, profileId, username, profileImageUrl, bio,
    followers, following, posts, isCurrentUser, isFollowing, 
    canViewPosts, isFollowActionInProgress
  ];

  ProfileLoaded copyWith({
    String? userId,
    String? profileId,
    String? username,
    String? profileImageUrl,
    String? bio,
    int? followers,
    int? following,
    List<Map<String, dynamic>>? posts,
    bool? isCurrentUser,
    bool? isFollowing,
    bool? canViewPosts,
    bool? isFollowActionInProgress,
  }) {
    return ProfileLoaded(
      userId: userId ?? this.userId,
      profileId: profileId ?? this.profileId,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isFollowing: isFollowing ?? this.isFollowing,
      canViewPosts: canViewPosts ?? this.canViewPosts,
      isFollowActionInProgress: isFollowActionInProgress ?? this.isFollowActionInProgress,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final supabase = Supabase.instance.client;

  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<FollowUser>(_onFollowUser);
    on<UnfollowUser>(_onUnfollowUser);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      // Get current user ID
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        emit(ProfileError("User not authenticated"));
        return;
      }

      // Check if current user is following the profile user
      bool isFollowing = false;
      if (!event.isCurrentUser) {
        final followData = await supabase
            .from('Followers')
            .select()
            .eq('follower_id', currentUserId)
            .eq('following_id', event.userId)
            .maybeSingle();
        
        isFollowing = followData != null;
      }

      // Load profile data
      final profileData = await supabase
          .from('Profile')
          .select('''
            *,
            User:user_id (
              username
            )
          ''')
          .eq('profile_id', event.profileId)
          .single();

      // Load posts if current user or if following
      final canViewPosts = event.isCurrentUser || isFollowing;
      List<Map<String, dynamic>> posts = [];
      
      if (canViewPosts) {
        final postsData = await supabase
            .from('Post')
            .select('''
              *,
              Profile!inner (
                pfp_image,
                user_id,
                User!inner (
                  username
                )
              )
            ''')
            .eq('profile_id', event.profileId)
            .order('created_at', ascending: false);

        posts = List<Map<String, dynamic>>.from(postsData);
      }

      // Emit loaded state
      emit(ProfileLoaded(
        userId: event.userId,
        profileId: event.profileId,
        username: profileData['User']['username'],
        profileImageUrl: profileData['pfp_image'],
        bio: profileData['bio'],
        followers: profileData['followers'] ?? 0,
        following: profileData['following'] ?? 0,
        posts: posts,
        isCurrentUser: event.isCurrentUser,
        isFollowing: isFollowing,
        canViewPosts: canViewPosts,
        isFollowActionInProgress: false,
      ));
    } catch (e) {
      emit(ProfileError("Failed to load profile: $e"));
    }
  }

  Future<void> _onFollowUser(FollowUser event, Emitter<ProfileState> emit) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        // First, emit a state showing the follow action is in progress
        emit(currentState.copyWith(isFollowActionInProgress: true));
        
        final currentUserId = supabase.auth.currentUser?.id;
        if (currentUserId == null) return;

        // Get current user's profile_id
        final currentUserProfileData = await supabase
            .from('Profile')
            .select('profile_id')
            .eq('user_id', currentUserId)
            .single();
        
        final currentUserProfileId = currentUserProfileData['profile_id'];

        // Add follow record
        await supabase.from('Followers').insert({
          'follower_id': currentUserId,
          'following_id': event.targetUserId,
          'created_at': DateTime.now().toIso8601String()
        });

        // Create notification for the follow action using profile IDs
        print('Attempting to create notification...');
        await supabase.from('Notifications').insert({
          'recipient_id': event.targetProfileId, // Target user's profile_id
          'sender_id': currentUserProfileId,     // Current user's profile_id
          'type': 'follow',
          'created_at': DateTime.now().toIso8601String(),
          'is_read': false
        });
        print('Notification created successfully!');

        // Update followers count
        await supabase
            .from('Profile')
            .update({'followers': currentState.followers + 1})
            .eq('profile_id', event.targetProfileId);

        // Update following count for current user
        await supabase
            .from('Profile')
            .update({'following': currentState.following + 1})
            .eq('user_id', currentUserId);

        // Load posts for this profile now that the user can see them
        final postsData = await supabase
            .from('Post')
            .select('''
              *,
              Profile!inner (
                pfp_image,
                user_id,
                User!inner (
                  username
                )
              )
            ''')
            .eq('profile_id', currentState.profileId)
            .order('created_at', ascending: false);

        final posts = List<Map<String, dynamic>>.from(postsData);

        // Emit a new state with updated information
        emit(currentState.copyWith(
          isFollowing: true,
          followers: currentState.followers + 1,
          canViewPosts: true,
          posts: posts,
          isFollowActionInProgress: false, // Action completed
        ));
      }
    } catch (e) {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        emit(currentState.copyWith(isFollowActionInProgress: false));
      }
      emit(ProfileError("Failed to follow user: $e"));
    }
  }

  Future<void> _onUnfollowUser(UnfollowUser event, Emitter<ProfileState> emit) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        // First, emit a state showing the unfollow action is in progress
        emit(currentState.copyWith(isFollowActionInProgress: true));
        
        final currentUserId = supabase.auth.currentUser?.id;
        if (currentUserId == null) return;

        // Remove follow record
        await supabase
            .from('Followers')
            .delete()
            .eq('follower_id', currentUserId)
            .eq('following_id', event.targetUserId);

        // Update followers count
        await supabase
            .from('Profile')
            .update({'followers': currentState.followers - 1})
            .eq('profile_id', event.targetProfileId);

        // Update following count for current user
        await supabase
            .from('Profile')
            .update({'following': currentState.following - 1})
            .eq('user_id', currentUserId);

        // Emit a new state with updated information
        emit(currentState.copyWith(
          isFollowing: false,
          followers: currentState.followers - 1,
          canViewPosts: false,
          posts: [], // Clear posts when unfollowing
          isFollowActionInProgress: false, // Action completed
        ));
      }
    } catch (e) {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        emit(currentState.copyWith(isFollowActionInProgress: false));
      }
      emit(ProfileError("Failed to unfollow user: $e"));
    }
  }
} 