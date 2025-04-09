import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Events
abstract class ActivityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotifications extends ActivityEvent {}

class MarkNotificationAsRead extends ActivityEvent {
  final String notificationId;
  
  MarkNotificationAsRead(this.notificationId);
  
  @override
  List<Object?> get props => [notificationId];
}

// States
abstract class ActivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<Map<String, dynamic>> notifications;
  
  ActivityLoaded(this.notifications);
  
  @override
  List<Object?> get props => [notifications];
}

class ActivityError extends ActivityState {
  final String message;
  
  ActivityError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final supabase = Supabase.instance.client;
  
  ActivityBloc() : super(ActivityLoading()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
  }
  
  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<ActivityState> emit
  ) async {
    emit(ActivityLoading());
    
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        print('ActivityBloc: User not authenticated');
        emit(ActivityError('User not authenticated'));
        return;
      }
      
      // Get the profile_id for the current user
      final profileData = await supabase
          .from('Profile')
          .select('profile_id')
          .eq('user_id', currentUserId)
          .single();
          
      final profileId = profileData['profile_id'];
      
      print('ActivityBloc: Fetching notifications for profile ID: $profileId');
      
      // Modified query with left join on Post to handle null post_id
      final response = await supabase
          .from('Notifications')
          .select('''
            *,
            sender:Profile!sender_id(
              profile_id,
              pfp_image,
              user_id,
              User:user_id(
                username
              )
            ),
            Post:post_id(
              post_id,
              image_path,
              caption
            )
          ''')
          .eq('recipient_id', profileId)
          .order('created_at', ascending: false);
      
      print('ActivityBloc: Found ${response.length} notifications');
      print('ActivityBloc: Sample notification: ${response.isNotEmpty ? response[0] : "none"}');
      
      emit(ActivityLoaded(List<Map<String, dynamic>>.from(response)));
    } catch (e, stackTrace) {
      print('ActivityBloc - Error loading notifications: $e');
      print('Stack trace: $stackTrace');
      emit(ActivityError('Error loading notifications: $e'));
    }
  }
  
  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<ActivityState> emit
  ) async {
    try {
      await supabase
          .from('Notifications')
          .update({'is_read': true})
          .eq('id', event.notificationId);
      
      add(LoadNotifications()); // Reload notifications
    } catch (e, stackTrace) {
      print('ActivityBloc - Error marking notification as read: $e');
      print('Stack trace: $stackTrace');
      emit(ActivityError('Error marking notification as read: $e'));
    }
  }
} 