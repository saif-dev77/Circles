import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Components/My_list_tile.dart';
import 'package:learningdart/Components/feed_post.dart';
import 'package:learningdart/Pages/ChatsPage.dart';
import 'package:learningdart/auth/auth_service.dart';
import 'package:learningdart/pages/activity_page.dart';
import 'package:learningdart/pages/event_page.dart';
import 'package:learningdart/pages/notice_board.dart';
import 'package:learningdart/pages/profile_page.dart';
import 'package:learningdart/pages/settings_page.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  String? post_url;
  final GlobalKey myKey = GlobalKey();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  String? _cachedProfilePicUrl;

@override
  void initState() {
    super.initState();
    debugPrint('Initializing FeedPage and fetching posts...');
    fetchpost();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject();
      if (renderBox != null) {
        print('Widget is laid out');
      }
    });
  }

  Future<void> fetchpost() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      final response = await supabase
        .from('Post')
        .select('''
          post_id,
          image_path,
          created_at,
          caption,
          likes,
          comments,
          Profile!inner (
            pfp_image,
            user_id,
            auth_user:user_id (
              username
            )
          )
        ''')
        .order('created_at', ascending: false);

      if (!mounted) return;
      if (response == null || response is! List) {
        setState(() {
          posts = [];
          isLoading = false;
        });
      } else {
        debugPrint('Fetched posts: $response');
        setState(() {
          posts = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      }
    } catch(e) {
      if (!mounted) return;
      setState(() {
        posts = [];
        isLoading = false;
      });
      debugPrint('Error fetching the post: $e');
    }
  }

  Future<void> _handleRefresh() async {
    await fetchpost();
    return Future.delayed(Duration(seconds: 1));
  }

  final authservice = AuthService();

  void logout() async{
    await authservice.signOut();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 72, 151, 151),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // header
              Column(children: [
                DrawerHeader(
                  child: Icon(
                    Icons.person,
                    color: Color.fromRGBO(214, 205, 205, 1),
                    size: 75,
                  ),
                ),
                // Profile list tyle
                GestureDetector(
                    onTap: () async {
                      final currentUser = supabase.auth.currentUser;
                      if (currentUser != null) {
                        try {
                          // Fetch current user's profile data
                          final profileData = await supabase
                              .from('Profile')
                              .select('profile_id, User!inner(username)')
                              .eq('user_id', currentUser.id)
                              .single();

                          if (mounted && profileData != null) {
                            final currentUserId = supabase.auth.currentUser?.id;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    userId: currentUser.id,
                                    profileId: profileData['profile_id'],
                                    username: profileData['User']['username'] ?? 'User',
                                    isCurrentUser: true,
                                  ),
                                ));
                          }
                        } catch (e) {
                          print('Error fetching profile data: $e');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error loading profile')),
                            );
                          }
                        }
                      }
                    },
                    child: MyListTile(
                      icon: Icons.person_3_rounded,
                      text: 'Profile',
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventPage(),
                          ));
                    },
                    child: MyListTile(
                      icon: Icons.event,
                      text: 'Events',
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticeBoard(),
                          ));
                    },
                    child: MyListTile(
                      icon: Icons.assignment_outlined,
                      text: 'Notices',
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ));
                  },
                  child: MyListTile(icon: Icons.settings, text: 'Settings'),
                )
              ]),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: logout,
                  child: MyListTile(icon: Icons.logout, text: 'Logout'),
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
          backgroundColor: Color.fromRGBO(0, 0, 0, 1),
          // Text
          title: const Text('Circles',
              style: TextStyle(
                  fontFamily: 'Daysone',
                  color: Color.fromRGBO(117, 216, 216, 1),
                  fontSize: 25)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Ionicons.heart_half_outline),
                  iconSize: 30,
                  color: const Color.fromRGBO(117, 216, 216, 1),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityPage(),
                        ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.forum_outlined),
                  iconSize: 30,
                  color: const Color.fromRGBO(117, 216, 216, 1),
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Chatspage(),));},
                ),
              ],
            ),
          ],
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : posts.isEmpty
            ? const Center(child: Text('No post available',style: TextStyle(color: Colors.white70),),)
            : LiquidPullToRefresh(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                color: Color.fromRGBO(117, 216, 216, 1),
                height: 100,
                backgroundColor: Colors.black,
                animSpeedFactor: 2,
                showChildOpacityTransition: false,
                springAnimationDurationInMilliseconds: 800,
                borderWidth: 2,
                // customIndicator: Container(
                //   width: 50,
                //   height: 50,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     border: Border.all(
                //       color: Color.fromRGBO(117, 216, 216, 1),
                //       width: 2,
                //     ),
                //   ),
                //   child: Center(
                //     child: _cachedProfilePicUrl != null
                //         ? ClipRRect(
                //             borderRadius: BorderRadius.circular(25),
                //             child: Image.network(
                //               _cachedProfilePicUrl!,
                //               width: 45,
                //               height: 45,
                //               fit: BoxFit.cover,
                //             ),
                //           )
                //         : CircularProgressIndicator(
                //             color: Color.fromRGBO(117, 216, 216, 1),
                //           ),
                //   ),
                // ),
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final profile = post['Profile'] as Map<String, dynamic>;
                    final user = profile['auth_user'] as Map<String, dynamic>;
                    final String imageUrl = post['image_path'] ?? '';
                    
                    return FeedPost(
                      profileimage: profile['pfp_image'] ?? '',
                      username: user['username'] ?? 'Unknown',
                      postimage: imageUrl,
                      no_of_likes: post['likes'] ?? 0,
                      no_of_comments: post['comments'] ?? 0,
                      caption: post['caption'] ?? '',
                      post_id: post['post_id'].toString(),
                    );
                  }
                ),
              )
          );
  }

  @override
  void dispose() {
    // Cancel any ongoing operations here
    super.dispose();
  }

  Future<void> _fetchAndCacheProfilePic(String userId) async {
    try {
      final profileData = await supabase
          .from('Profile')
          .select('pfp_image')
          .eq('user_id', userId)
          .single();
      
      if (mounted && profileData != null && profileData['pfp_image'] != null) {
        setState(() {
          _cachedProfilePicUrl = profileData['pfp_image'];
        });
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
  }
}
