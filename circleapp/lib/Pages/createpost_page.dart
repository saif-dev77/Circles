// ignore_for_file: camel_case_types
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'First_page.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _createpost();
}

class _createpost extends State<CreatePostPage> {
  TextEditingController _captioncontroller = TextEditingController();
  File? _imagefile;
  final supabase = Supabase.instance.client;

  //pick an imagfe to upload
  Future pickimage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 70,
    );

    if (image != null) {
      // Crop image immediately after selection
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: const Color.fromRGBO(117, 216, 216, 1),
            statusBarColor: Colors.black,
            backgroundColor: Colors.black,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _imagefile = File(croppedFile.path);
        });
      }
    }
  }

  //click an image to upload
  Future clickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Crop image immediately after capturing
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: const Color.fromRGBO(117, 216, 216, 1),
            statusBarColor: Colors.black,
            backgroundColor: Colors.black,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _imagefile = File(croppedFile.path);
        });
      }
    }
  }

  //upload
  Future uploadImage() async {
    try {
      if (_imagefile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an image first!")),
        );
        return;
      }

      // Get current user ID
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login first!")),
        );
        return;
      }

      final userId = currentUser.id; // Store user ID
      // Get the profile ID as a string
      final profileResult = await Supabase.instance.client
          .from('Profile')
          .select('profile_id')
          .eq('user_id', userId)
          .single();

// Extract the profile_id value
      final profileId = profileResult['profile_id'] as String;

      // Generate unique filename
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'posts/$fileName';

      // Upload image to storage
      await supabase.storage.from('Images').upload(filePath, _imagefile!);

      // Get public URL
      final imageUrl = supabase.storage.from('Images').getPublicUrl(filePath);

      // Insert into Post table with user_id
      await supabase.from('Post').insert({
        'user_id': userId, // Insert the current user's ID
        'image_path': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'profile_id': profileId.toString(),
        'likes': 0, // Initialize likes count
        'comments': 0, // Initialize comments count
        'caption': _captioncontroller.text,
      });

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post uploaded successfully!")),
        );

        // Navigate to homepage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirstPage()),
        );
      }
    } catch (e) {
      print('Error uploading post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload post: $e')),
        );
      }
    }
  }

  // Add cropImage function
  Future<void> cropImage() async {
    if (_imagefile == null) return;

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imagefile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: const Color.fromRGBO(117, 216, 216, 1),
            statusBarColor: Colors.black,
            backgroundColor: Colors.black,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _imagefile = File(croppedFile.path);
        });
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FirstPage()));
          },
          icon: Icon(
            Icons.clear_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          "Upload post",
          style: GoogleFonts.daysOne(
              color: Color.fromRGBO(117, 216, 216, 1), fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(
                Icons.download_done_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: uploadImage,
            ),
          )
        ],
      ),
      body: ListView(children: [
        Column(
          children: [
            SizedBox(
              height: 10,
            ),
            //image preview
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Color.fromRGBO(117, 216, 216, 1),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  ClipRect(
                    child: _imagefile != null
                        ? Image.file(
                            _imagefile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 175, left: 70),
                            child: Text(
                              "No Image Selected!!!",
                              style: GoogleFonts.daysOne(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  ),
                  // Crop button
                  if (_imagefile != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(117, 216, 216, 1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.crop,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: cropImage,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //button to pick image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: pickimage,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(117, 216, 216, 1),
                        foregroundColor: Colors.black,
                        elevation: 10,
                        shadowColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: const Size(70, 70)),
                    child: ImageIcon(
                      AssetImage(
                        'assets/Images/upload.png',
                      ),
                      size: 40,
                    )),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: clickImage,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(117, 216, 216, 1),
                        foregroundColor: Colors.black,
                        elevation: 10,
                        shadowColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: const Size(70, 70)),
                    child: ImageIcon(
                      AssetImage(
                        'assets/Images/photo-camera.png',
                      ),
                      size: 30,
                    )),
              ],
            ),

            // ElevatedButton(
            //       onPressed: uploadImage,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Color.fromRGBO(117, 216, 216, 1),
            //         foregroundColor: Colors.black,
            //         elevation: 10,
            //         shadowColor: Colors.white,
            //       ),
            //       child: Text(
            //         "Upload",
            //         style: GoogleFonts.daysOne(fontSize: 15),
            //   ))

            SizedBox(
              height: 30,
            ),

            Row(
              children: [
                Text(
                  "  Add",
                  style: GoogleFonts.daysOne(
                      color: Color.fromRGBO(117, 216, 216, 1), fontSize: 20),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Caption",
                  style: GoogleFonts.daysOne(color: Colors.white, fontSize: 20),
                )
              ],
            ),

            SizedBox(
              height: 8,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: _captioncontroller,
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
          ],
        ),
      ]),
    );
  }
}
