// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Components/abs_account_box.dart';
import 'package:learningdart/Components/abs_searchbar.dart';
import 'package:learningdart/Components/carousel.dart';
import 'package:learningdart/Components/search_hist.dart';
import 'package:learningdart/Pages/First_page.dart';
import 'package:learningdart/Pages/home_page.dart';
import 'package:learningdart/Pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final supabase = Supabase.instance.client;
  String query = '';
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> recentSearches = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load recent searches from Supabase with joined data
  Future<void> loadRecentSearches() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await supabase
          .from('recent_searches')
          .select('''
            *,
            searched_user:searched_user_id (
              user_id,username
            ),
            Profile:profile_id (
              profile_id,pfp_image
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(5);

      setState(() {
        recentSearches = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error loading recent searches: $e');
    }
  }

  // Save search to recent searches
  Future<void> saveSearch(String searchedUserId, String profileId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Check if this search already exists
      final existing = await supabase
          .from('recent_searches')
          .select()
          .eq('user_id', userId)
          .eq('searched_user_id', searchedUserId)
          .maybeSingle();

      if (existing != null) {
        // Update the timestamp of existing search
        await supabase
            .from('recent_searches')
            .update({'created_at': DateTime.now().toIso8601String()})
            .eq('id', existing['id']);
      } else {
        // Add new search
        await supabase.from('recent_searches').insert({
          'user_id': userId,
          'searched_user_id': searchedUserId,
          'profile_id': profileId,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // Reload recent searches
      await loadRecentSearches();
    } catch (e) {
      print('Error saving search: $e');
    }
  }

  // Search users
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await supabase
          .from('User')
          .select('''
            user_id,
            username,
            Profile!inner (
              profile_id,
              pfp_image
            )
          ''')
          .ilike('username', '%$query%')
          .limit(10);

      setState(() {
        searchResults = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error searching users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildSearchResults() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final user = searchResults[index];
        
        // Handle Profile data which might be a List or a single item
        final profileData = user['Profile'];
        final profile = profileData is List ? profileData.first : profileData;
        
        if (profile == null) {
          return const SizedBox();
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: profile['pfp_image'] != null 
                ? NetworkImage(profile['pfp_image'].toString())
                : null,
            child: profile['pfp_image'] == null 
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          title: Text(
            user['username'] ?? 'Unknown User',
            style: const TextStyle(color: Colors.white),
          ),
          onTap: () async {
            if (user['user_id'] != null && profile['profile_id'] != null) {
              await saveSearch(
                user['user_id'].toString(),
                profile['profile_id'].toString()
              );
              
              // Get current user's ID to compare
              final currentUserId = supabase.auth.currentUser?.id;
              
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userId: user['user_id'].toString(),
                      profileId: profile['profile_id'].toString(),
                      username: user['username'] ?? 'Unknown User',
                      isCurrentUser: currentUserId == user['user_id'], // Compare IDs to determine if it's current user
                    ),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  Widget _buildRecentSearches() {
    return ListView.builder(
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        final search = recentSearches[index];
        final searchedUserData = search['searched_user'];
        final profileData = search['Profile'];
        
        if (searchedUserData == null) {
          print('No searched user data found for search: $search');
          return const SizedBox();
        }
        
        final searchedUser = searchedUserData as Map<String, dynamic>;
        final profile = profileData as Map<String, dynamic>?;
        
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: profile?['pfp_image'] != null 
                ? NetworkImage(profile!['pfp_image']) 
                : null,
            child: profile?['pfp_image'] == null 
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          title: Text(
            searchedUser['username'] ?? 'Unknown User',
            style: const TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () async {
              if (search['id'] != null) {
                await supabase
                    .from('recent_searches')
                    .delete()
                    .eq('id', search['id']);
                loadRecentSearches();
              }
            },
          ),
          onTap: () {
            // Navigate to profile page when recent search is tapped
            final currentUserId = supabase.auth.currentUser?.id;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  userId: searchedUser['user_id'],
                  profileId: search['profile_id'],
                  username: searchedUser['username'] ?? 'Unknown User',
                  isCurrentUser: currentUserId == searchedUser['user_id'].toString(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
          },
          icon: Icon(Icons.arrow_back_ios_new,
          color: Colors.tealAccent,
          size: 25,)
        ),
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(left: 85),
          child: Text(
            "Explore",
            style: GoogleFonts.daysOne(color: Colors.tealAccent, fontSize: 25),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar (existing code)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.tealAccent, width: 1),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.tealAccent),
                ),
                onChanged: (value) {
                  searchUsers(value);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Recent Searches Header
            if (_searchController.text.isEmpty && recentSearches.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Recent Searches',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Search Results or Recent Searches
            Expanded(
              child: Column(
                children: [
                  // Show recent searches in a horizontal list if search bar is empty
                  if (_searchController.text.isEmpty && recentSearches.isNotEmpty)
                    Container(
                      height: 100,
                      child: _buildRecentSearches(),
                    ),
                    
                  // Divider if showing recent searches
                  if (_searchController.text.isEmpty && recentSearches.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Colors.grey),
                    ),
                    
                  // Search results or remaining space
                  Expanded(
                    child: _searchController.text.isEmpty
                        ? Container() // Empty container when search is empty
                        : _buildSearchResults(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
