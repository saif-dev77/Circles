import 'package:flutter/material.dart';
import 'package:learningdart/Pages/profile_page.dart';
import 'package:learningdart/Pages/post_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityBar extends StatelessWidget {
  final Map<String, dynamic> notification;
  final Function onTap;

  const ActivityBar({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sender = notification['sender'];
    final senderUser = sender['User'];
    final username = senderUser['username'] ?? 'Unknown User';
    final pfpImage = sender['pfp_image'];
    final post = notification['Post'];
    final notificationType = notification['type'];
    final createdAt = _formatTimestamp(notification['created_at']);

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: notification['is_read'] ? null : Border.all(
          color: Color.fromRGBO(117, 216, 216, 1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile picture (clickable)
          GestureDetector(
            onTap: () => _navigateToProfile(context, sender),
            child: CircleAvatar(
              backgroundImage: pfpImage != null
                  ? NetworkImage(pfpImage)
                  : AssetImage('assets/Images/defaultpfp.jpg') as ImageProvider,
              radius: 25,
            ),
          ),
          SizedBox(width: 10),
          // Notification content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    children: [
                      // Username (wrapped in GestureDetector in the outer layout)
                      TextSpan(
                        text: username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(text: _getNotificationText(notificationType)),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  createdAt,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          // Post thumbnail for like notifications
          if (notificationType == 'like' && post != null && post['image_path'] != null)
            GestureDetector(
              onTap: () => _navigateToPost(context, post),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: NetworkImage(post['image_path']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getNotificationText(String type) {
    switch (type) {
      case 'follow':
        return ' started following you';
      case 'like':
        return ' liked your post';
      case 'comment':
        return ' commented on your post';
      default:
        return ' interacted with you';
    }
  }

  String _formatTimestamp(String timestamp) {
    final now = DateTime.now();
    final notificationTime = DateTime.parse(timestamp);
    final difference = now.difference(notificationTime);

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
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return '${notificationTime.day}/${notificationTime.month}/${notificationTime.year}';
    }
  }

  void _navigateToProfile(BuildContext context, Map<String, dynamic> sender) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          userId: sender['user_id'],
          profileId: sender['profile_id'],
          username: sender['User']['username'] ?? 'Unknown User',
          isCurrentUser: false,
        ),
      ),
    );
  }

  void _navigateToPost(BuildContext context, Map<String, dynamic> post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(post: post),
      ),
    );
  }
}
