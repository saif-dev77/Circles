import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:learningdart/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostPFPPage extends StatefulWidget {
  final String username;
  final String email;
  final DateTime? dob;
  final String gender;
  final String password;

  const PostPFPPage({
    super.key, 
    required this.email, 
    required this.username,
    required this.password,
    this.dob,
    required this.gender,
  });

  @override
  State<PostPFPPage> createState() => _PostPFPPageState();
}

class _PostPFPPageState extends State<PostPFPPage> {
  File? _imageFile;
  String? imagePath;
  final supabase = Supabase.instance.client;

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          imagePath = image.path;
        });
        print('Image picked successfully: ${image.path}');
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> SignUpwithoutpfp() async {
    try {
      if(_imageFile != null){
        signUp();
      }

      else{
        final AuthResponse res = await supabase.auth.signUp(
        email: widget.email,
        password: widget.password,
      );
      if (res.user != null) {
        final userId = res.user!.id;

        

        try {
          // First insert into User table
          await supabase.from('User').insert({
            'user_id': userId,
            'username': widget.username,
            'email': widget.email,
            'DOB': widget.dob?.toIso8601String(),
            'gender': widget.gender,
          });

          // Then insert into Profile table with the same user_id
          await supabase.from('Profile').insert({
            'user_id': userId,  // This will reference the User table
            'pfp_image': '',
            'followers': 0,
            'following': 0,
          });

          // Navigate to AuthGate on success
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthGate()),
              (route) => false,
            );
          }
        } catch (e) {
          // If there's an error, try to clean up
          print('Error during database insertion: $e');
          // Optionally delete the uploaded image
          
          
          // Delete the auth user if database insertion failed
          await supabase.auth.admin.deleteUser(userId);
          
          throw e; // Re-throw to be caught by outer catch block
        }
      }
      }
    }catch (e) {
      print('Error during signup: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      }
    }
  }
  Future<void> signUp() async {
    try {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a profile picture')),
        );
        return;
      }

      // First, create the auth user
      final AuthResponse res = await supabase.auth.signUp(
        email: widget.email,
        password: widget.password,
      );

      if (res.user != null) {
        final userId = res.user!.id;

        // Generate a unique file name for the image
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = 'profile_pictures/$fileName';

        // Upload image to Supabase Storage
        await supabase.storage
            .from('profile_pictures')
            .upload(filePath, _imageFile!);

        // Get the public URL of the uploaded image
        final String imageUrl = supabase.storage
            .from('profile_pictures')
            .getPublicUrl(filePath);

        try {
          // First insert into User table
          await supabase.from('User').insert({
            'user_id': userId,
            'username': widget.username,
            'email': widget.email,
            'DOB': widget.dob?.toIso8601String(),
            'gender': widget.gender,
          });

          // Then insert into Profile table with the same user_id
          await supabase.from('Profile').insert({
            'user_id': userId,  // This will reference the User table
            'pfp_image': imageUrl,
            'followers': 0,
            'following': 0,
          });

          // Navigate to AuthGate on success
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthGate()),
              (route) => false,
            );
          }
        } catch (e) {
          // If there's an error, try to clean up
          print('Error during database insertion: $e');
          // Optionally delete the uploaded image
          await supabase.storage
              .from('profile_pictures')
              .remove([filePath]);
          
          // Delete the auth user if database insertion failed
          await supabase.auth.admin.deleteUser(userId);
          
          throw e; // Re-throw to be caught by outer catch block
        }
      }
    } catch (e) {
      print('Error during signup: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Back Button
          Positioned(
            top: 35,
            left: 4,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          // Add "Profile" text
          Positioned(
            top: 130,
            left: 8,
            child: Text(
              "Profile",
              style: GoogleFonts.daysOne(
                color: Color.fromRGBO(117, 216, 216, 1),
                fontSize: 45,
              ),
            ),
          ),
          // Add "Setup" text
          Positioned(
            top: 170,
            left: 8,
            child: Text(
              "Setup",
              style: GoogleFonts.daysOne(
                color: Colors.white,
                fontSize: 35,
              ),
            ),
          ),
          // Descriptive text
          Positioned(
            top: 250,
            left: 8,
            right: 8,
            child: Text(
              "Get started by setting up a profile picture so that you can mogg your fellow peeps!!",
              textAlign: TextAlign.center,
              style: GoogleFonts.daysOne(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          // Center image preview and upload button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image preview
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromRGBO(117, 216, 216, 1),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.white,
                          ),
                  ),
                ),
                SizedBox(height: 30),
                // Upload button
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromRGBO(117, 216, 216, 1),
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    onPressed: pickImage,
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Color.fromRGBO(117, 216, 216, 1),
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sign Up Button
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(117, 216, 216, 1),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Sign Up',
                style: GoogleFonts.daysOne(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Positioned(
            top: 38,
            right: 10,
            child: TextButton(
              onPressed: SignUpwithoutpfp,
              child: Text('Skip',
              style: GoogleFonts.daysOne(color: Colors.white, fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }
}
