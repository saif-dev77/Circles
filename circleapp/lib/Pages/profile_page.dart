// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Components/our_profile_stats.dart';
import 'package:learningdart/Components/post_types.dart';
import 'package:learningdart/Pages/EditProfilePage.dart';
import 'package:learningdart/auth/auth_service.dart';
import 'package:learningdart/blocs/profile_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String profileId;
  final String username;
  final bool isCurrentUser;

  const ProfilePage({
    Key? key,
    required this.userId,
    required this.profileId,
    required this.username,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authservice = AuthService();
  final supabase = Supabase.instance.client;
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
    _profileBloc.add(LoadProfile(
      userId: widget.userId,
      profileId: widget.profileId,
      isCurrentUser: widget.isCurrentUser,
    ));
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  Future<void> updateProfilePicture() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Color.fromRGBO(117, 216, 216, 1)),
          ),
          title: Text(
            'Update Profile Picture',
            style: GoogleFonts.daysOne(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Upload from device button
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _pickAndUploadImage();
                },
                child: Row(
                  children: [
                    Icon(Icons.upload, color: Color.fromRGBO(117, 216, 216, 1)),
                    SizedBox(width: 10),
                    Text(
                      'Upload from device',
                      style: GoogleFonts.daysOne(
                        color: Color.fromRGBO(117, 216, 216, 1),
                      ),
                    ),
                  ],
                ),
              ),
              // Remove profile picture button
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _removeProfilePicture();
                },
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      'Remove picture',
                      style: GoogleFonts.daysOne(color: Colors.red),
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

  Future<void> _pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final currentUserId = authservice.getCurrentUserId();
        if (currentUserId == null) return;

        // Generate unique filename
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = 'profile_pictures/$fileName';

        // Upload new image
        await Supabase.instance.client.storage
            .from('profile_pictures')
            .upload(filePath, File(image.path));

        // Get public URL
        final String imageUrl = await Supabase.instance.client.storage
            .from('profile_pictures')
            .getPublicUrl(filePath);

        // Update Profile table
        await Supabase.instance.client
            .from('Profile')
            .update({'pfp_image': imageUrl})
            .eq('user_id', currentUserId);

        // Reload profile
        _profileBloc.add(LoadProfile(
          userId: widget.userId,
          profileId: widget.profileId,
          isCurrentUser: widget.isCurrentUser,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture: $e')),
        );
      }
    }
  }

  Future<void> _removeProfilePicture() async {
    try {
      final currentUserId = authservice.getCurrentUserId();
      if (currentUserId == null) return;

      // Update Profile table with empty string for pfp_image
      await Supabase.instance.client
          .from('Profile')
          .update({'pfp_image': ''})
          .eq('user_id', currentUserId);

      // Reload profile
      _profileBloc.add(LoadProfile(
        userId: widget.userId,
        profileId: widget.profileId,
        isCurrentUser: widget.isCurrentUser,
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove profile picture: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
                backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Daysone',
                    fontSize: 25,
                    color: Color.fromRGBO(117, 216, 216, 1)
                  ),
                ),
                centerTitle: true,
              ),
              body: Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.black,
            );
          } else if (state is ProfileLoaded) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              appBar: AppBar(
                iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
                backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Daysone',
                    fontSize: 25,
                    color: Color.fromRGBO(117, 216, 216, 1)
                  ),
                ),
                centerTitle: true,
                actions: state.isCurrentUser ? [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage())
                    ),
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.daysOne(
                        color: Color.fromRGBO(117, 216, 216, 1)
                      ),
                    )
                  )
                ] : [],
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    const SizedBox(height: 30),
                    // Profile picture with edit button only for current user
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.white,
                                      offset: Offset(4, 4),
                                      spreadRadius: 2
                                    ),
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.cyan,
                                      offset: Offset(-4, -4),
                                      spreadRadius: 2
                                    ),
                                  ]
                                ),
                                child: CircleAvatar(
                                  backgroundImage: state.profileImageUrl != null && state.profileImageUrl!.isNotEmpty
                                      ? NetworkImage(state.profileImageUrl!)
                                      : AssetImage('assets/Images/defaultpfp.jpg') as ImageProvider,
                                  radius: 70,
                                ),
                              ),
                              // Only show edit button for current user
                              if (state.isCurrentUser)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(117, 216, 216, 1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.edit, color: Colors.black),
                                      onPressed: updateProfilePicture,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Username
                    Text(
                      state.username,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    // Follow/Unfollow button for other users' profiles
                    if (!state.isCurrentUser)
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isFollowing 
                                ? Colors.grey 
                                : Color.fromRGBO(117, 216, 216, 1),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            minimumSize: Size(120, 40),
                            disabledBackgroundColor: state.isFollowing 
                                ? Colors.grey.withOpacity(0.7) 
                                : Color.fromRGBO(117, 216, 216, 0.7),
                          ),
                          onPressed: state.isFollowActionInProgress 
                              ? null
                              : () {
                                  if (state.isFollowing) {
                                    context.read<ProfileBloc>().add(UnfollowUser(
                                      targetUserId: state.userId,
                                      targetProfileId: state.profileId,
                                    ));
                                  } else {
                                    context.read<ProfileBloc>().add(FollowUser(
                                      targetUserId: state.userId,
                                      targetProfileId: state.profileId,
                                    ));
                                  }
                                },
                          child: state.isFollowActionInProgress
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  state.isFollowing ? 'Unfollow' : 'Follow',
                                  style: GoogleFonts.daysOne(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    const SizedBox(height: 25),
                    // Stats
                    OurProfileStats(
                      followers: state.followers.toString(),
                      following: state.following.toString(),
                    ),
                    const SizedBox(height: 35),
                    // Bio
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        state.bio ?? " ",
                        style: TextStyle(color: Colors.white70, fontSize: 15)
                      ),
                    ),
                    const SizedBox(height: 15),
                    PostTypes(posts: state.posts),
                    const SizedBox(height: 10),
                    
                    // Posts - only shown if current user or if following
                    if (!state.canViewPosts && !state.isCurrentUser)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Text(
                            'Follow this user to see their posts',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ),
                      
                    // Display posts if canViewPosts is true
                    if (state.canViewPosts)
                      ...state.posts.map((post) => PostCard(post: post)).toList(),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
                backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                title: Text('Error'),
              ),
              body: Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.black,
            );
          }
          
          // Default loading state
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
            backgroundColor: Colors.black,
          );
        },
      ),
    );
  }
}

// Simple Post Card Widget (implement your own design)
class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  
  const PostCard({Key? key, required this.post}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['image_url'] != null && post['image_url'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post['image_url'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 8),
            Text(
              post['content'] ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
