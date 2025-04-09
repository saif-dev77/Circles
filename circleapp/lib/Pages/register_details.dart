import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:learningdart/Pages/First_page.dart';
import 'package:learningdart/Pages/gender_and_dob.dart';
import 'package:learningdart/Pages/login_page.dart';
import 'package:learningdart/Pages/register_page.dart';
import 'package:learningdart/auth/auth_gate.dart';
import 'package:learningdart/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDetails extends StatefulWidget {
  final String email;

  const UserDetails({super.key, required this.email});

  @override
  State<UserDetails> createState() => _UserdetailsState();
}

class _UserdetailsState extends State<UserDetails> {
  final authService = AuthService();
  // bool _visible = true;
  final usernamecontroller = TextEditingController();

  Future<bool> isUsernameAvailable() async {
    final username = usernamecontroller.text;
    final response = await Supabase.instance.client
        .from('User')
        .select('username')
        .eq('username', username)
        .maybeSingle(); // Get a single row if it exists, or null

    return response == null; // If null, username is available
  }

  // final passwordcontroller = TextEditingController();
  // final confirmpasswordcontroller = TextEditingController();

  // void signUp() async {
  //   final username = usernamecontroller.text;
  //   final password = passwordcontroller.text;
  //   final confirmpassword = confirmpasswordcontroller.text;
  //   final email = widget.email.trim();

  //   //check if both passwords do match
  //   if (password != confirmpassword) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Passwords Don't Match"),
  //     ));

  //     return;
  //   }

  //   try {
  //     await authService.signUpWithEmailPassword(email, password);
  //     await Supabase.instance.client.from("User").insert({'email': email, 'username': username, 'password': password});
  //     Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => AuthGate()),
  //   );
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text("Error: $e"),
  //       ));
  //     }
  //   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
              child: Padding(
            padding: const EdgeInsets.only(top: 25, left: 4),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 30,
                )),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 130, left: 8),
            child: Text(
              "Enter a",
              style: GoogleFonts.daysOne(
                  color: Color.fromRGBO(117, 216, 216, 1), fontSize: 45),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 170, left: 10),
            child: Text(
              "Username",
              style: GoogleFonts.daysOne(color: Colors.white, fontSize: 35),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 270, left: 175, right: 175),
            child: Icon(
              Ionicons.person_outline,
              color: Color.fromRGBO(117, 216, 216, 1),
              size: 70,
            ),
          ),
          Positioned(
              top: 650,
              left: 40,
              child: Transform.scale(
                  scale: 2,
                  child: DottedBorder(
                      borderType: BorderType.Circle,
                      dashPattern: [1.3, 1],
                      strokeWidth: 1,
                      radius: Radius.circular(20),
                      color: const Color.fromARGB(255, 170, 165, 165),
                      child: Container(
                        width: 330,
                        height: 350,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                      )))),
          Positioned(
            top: 390,
            left: 70,
            child: Container(
              height: 270,
              width: 270,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(117, 216, 216, 1),
                  shape: BoxShape.circle),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80, left: 24),
                    child: Text(
                      'Enter a Valid Username',
                      style: GoogleFonts.daysOne(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 105, left: 15, right: 15),
                    child: TextField(
                      controller: usernamecontroller,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter Username",
                          hintStyle: GoogleFonts.daysOne(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5),
                            fontSize: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 410, left: 20, right: 20),
          //   child: TextField(
          //     controller: passwordcontroller,
          //     obscureText: _visible,

          //     decoration: InputDecoration(

          //         hintText: "Enter Password",
          //         suffixIcon: IconButton(
          //           onPressed: () {
          //             setState(() {
          //               _visible = !_visible;
          //             });
          //           },
          //           icon: Icon(
          //             !_visible
          //                 ? Icons.visibility_outlined
          //                 : Icons.visibility_off_outlined,
          //           ),
          //         ),
          //         hintStyle: GoogleFonts.daysOne(
          //             color: const Color.fromARGB(249, 77, 72, 72),
          //             fontSize: 15),
          //         fillColor: const Color.fromARGB(255, 255, 255, 255),
          //         filled: true,
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(20),
          //             borderSide: BorderSide(
          //                 color: Color.fromRGBO(117, 216, 216, 1), width: 4)),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(20),
          //             borderSide: BorderSide(
          //                 color: Color.fromRGBO(117, 216, 216, 1), width: 4))),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 510, left: 20, right: 20),
          //   child: TextField(
          //     controller: confirmpasswordcontroller,
          //     decoration: InputDecoration(
          //         hintText: "Confirm Password",
          //         hintStyle: GoogleFonts.daysOne(
          //             color: const Color.fromARGB(249, 77, 72, 72),
          //             fontSize: 15),
          //         fillColor: const Color.fromARGB(255, 255, 255, 255),
          //         filled: true,
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(20),
          //             borderSide: BorderSide(
          //                 color: Color.fromRGBO(117, 216, 216, 1), width: 4)),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(20),
          //             borderSide: BorderSide(
          //                 color: Color.fromRGBO(117, 216, 216, 1), width: 4))),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 710, left: 155),
            child: ElevatedButton(
                onPressed: () async {
                  if (usernamecontroller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a username")),
                    );
                    return;
                  }

                  bool available = await isUsernameAvailable();
                  if (available) {
                    // Proceed with the next steps (e.g., save data, navigate)
                    // For example:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenderandDOB(
                                email: widget.email,
                                username: usernamecontroller.text,
                              )),
                    );
                  } else {
                    // Show error if username is already taken
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Username is already taken")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                    elevation: 6,
                    shadowColor: Colors.white,
                    animationDuration: Durations.long1),
                child: Text(
                  "Next",
                  style: GoogleFonts.daysOne(
                    fontSize: 20,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
