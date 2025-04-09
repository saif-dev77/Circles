import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Pages/First_page.dart';
import 'package:learningdart/Pages/profile_page.dart';
import 'package:learningdart/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _biocontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchBio();
    isUsernameAvailable();
  }

  final authservice = AuthService();
  String? username;

  Future<bool> isUsernameAvailable() async {
    final username = _usernamecontroller.text;
    final response = await Supabase.instance.client
        .from('User')
        .select('username')
        .eq('username', username)
        .maybeSingle(); // Get a single row if it exists, or null

    return response == null; // If null, username is available
  }

  Future<void> fetchUsername() async {
    try {
      final currentUserId = authservice.getCurrentUserId();
      if (currentUserId != null) {
        final data = await Supabase.instance.client
            .from('User')
            .select('username')
            .eq('user_id', currentUserId)
            .single();

        if (data != null) {
          setState(() {
            _usernamecontroller.text = data['username'];
          });
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  Future<void> fetchBio() async {
    try {
      final currentUserId = authservice.getCurrentUserId();
      if (currentUserId != null) {
        final data = await Supabase.instance.client
            .from('Profile')
            .select('bio')
            .eq('user_id', currentUserId)
            .single();

        if (data != null) {
          setState(() {
            _biocontroller.text = data['bio'];
          });
        }
      }
    } catch (e) {
      print('Error fetching bio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromRGBO(255, 255, 255, 1)),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.daysOne(
              color: Color.fromRGBO(117, 216, 216, 1), fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: IconButton(
              onPressed: () async {
                if (_usernamecontroller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Username cannot be empty")),
                  );
                  return;
                }

                bool available = await isUsernameAvailable();
                if (available) {
                  // Proceed with the next steps (e.g., save data, navigate)
                  try {
                    final currentUserId = authservice.getCurrentUserId();
                    if (currentUserId == null) return;

                    final String username = _usernamecontroller.text;
                    final String bio = _biocontroller.text;

                    await Supabase.instance.client.from('User').update(
                        {'username': username}).eq('user_id', currentUserId);

                    await Supabase.instance.client
                        .from('Profile')
                        .update({'bio': bio}).eq('user_id', currentUserId);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Failed to update values: $e')),
                      );
                    }
                  }
                  
                  Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const FirstPage()),
              (route) => false,
            );

                } else {
                  // Show error if username is already taken
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Username is already taken")),
                  );
                }
              },
              icon: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 35,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Text(
                  "Change",
                  style: GoogleFonts.daysOne(
                      color: Color.fromRGBO(255, 255, 255, 1), fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 10),
                child: Text(
                  "Username",
                  style: GoogleFonts.daysOne(
                      color: Color.fromRGBO(117, 216, 216, 1), fontSize: 25),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              controller: _usernamecontroller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 146, 144, 144),
                        width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 113, 111, 111),
                        width: 2),
                  )),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Text(
                  "Add",
                  style: GoogleFonts.daysOne(
                      color: Color.fromRGBO(255, 255, 255, 1), fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 10),
                child: Text(
                  "Bio",
                  style: GoogleFonts.daysOne(
                      color: Color.fromRGBO(117, 216, 216, 1), fontSize: 25),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              controller: _biocontroller,
              maxLines: 8,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 146, 144, 144),
                        width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 113, 111, 111),
                        width: 2),
                  )),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
