// ignore_for_file: camel_case_types, avoid_unnecessary_containers

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Pages/register_page.dart';

import 'package:learningdart/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  void login() async {
    // prepare data
    final email = emailController.text;
    final password = passController.text;

    // attempt login......
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: 150,
              left: 8,
              child: Container(
                height: 100,
                color: const Color.fromARGB(255, 0, 0, 0),
                child: Text(
                  "Sign          ",
                  style: GoogleFonts.daysOne(color: Colors.white, fontSize: 50),
                ),
              ),
            ),
            Positioned(
              top: 205,
              left: 12,
              child: Container(
                height: 80,
                color: const Color.fromARGB(0, 0, 0, 0),
                child: Text(
                  "In                                      ",
                  style: GoogleFonts.daysOne(
                      color: Color.fromRGBO(117, 216, 216, 1), fontSize: 30),
                ),
              ),
            ),
            Positioned(
                top: 650,
                left: 40,
                child: Transform.scale(
                    scale: 2,
                    child: DottedBorder(
                        borderType: BorderType.Circle,
                        dashPattern: [1.5, 1],
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
                      padding:
                          const EdgeInsets.only(top: 70, left: 15, right: 15),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Your Email",
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 130, left: 15, right: 15),
                      child: TextField(
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Password",
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
            Positioned(
                top: 730,
                left: 155,
                child: ElevatedButton(
                  onPressed: login,
                  child: Icon(
                    Icons.arrow_right_alt_sharp,
                    size: 50,
                    color: Colors.black,
                  ),
                )),
            Positioned(
              top: 790,
              left: 65,
              child: Text(
                "Don't have an account??",
                style: GoogleFonts.daysOne(color: Colors.white, fontSize: 14),
              ),
            ),
            Positioned(
              top: 790,
              left: 265,
              child: GestureDetector(
                  child: Text(
                "Sign Up",
                style: GoogleFonts.daysOne(
                    color: const Color.fromRGBO(117, 216, 216, 1),
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color.fromRGBO(117, 216, 216, 1)),
              ),
              
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },),

              
            )
          ],
        ),
      ),
    );
  }
}
