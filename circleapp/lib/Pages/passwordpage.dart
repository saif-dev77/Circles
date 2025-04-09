import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Pages/gender_and_dob.dart';
import 'package:learningdart/Pages/postpfppage.dart';

class PasswordPage extends StatefulWidget {
  final String username;
  final String email;
  final DateTime? dob;
  final String gender;

  const PasswordPage({
    super.key,
    required this.email,
    required this.username,
    this.dob,
    required this.gender,

  });

  @override
  State<PasswordPage> createState() => _PasswordPage();
}

class _PasswordPage extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 25,
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
          Positioned(
            top: 130,
            left: 8,
            child: Text(
              "Create",
              style: GoogleFonts.daysOne(
                color: Color.fromRGBO(117, 216, 216, 1),
                fontSize: 45,
              ),
            ),
          ),
          Positioned(
            top: 170,
            left: 8,
            child: Text(
              "Password",
              style: GoogleFonts.daysOne(
                color: Colors.white,
                fontSize: 35,
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
            top: 370,
            left: 50,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Color.fromRGBO(117, 216, 216, 1),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 30),
                    child: Text(
                      'Enter Password',
                      style: GoogleFonts.daysOne(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 85, left: 15, right: 15),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        hintText: "Enter Password",
                        hintStyle: GoogleFonts.daysOne(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.5),
                          fontSize: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150, left: 30),
                    child: Text(
                      'Confirm Password',
                      style: GoogleFonts.daysOne(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 175, left: 15, right: 15),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        hintText: "Confirm Password",
                        hintStyle: GoogleFonts.daysOne(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.5),
                          fontSize: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 100,
            right: 100,
            child: ElevatedButton(
              onPressed: () {
                if (_passwordController.text.isEmpty ||
                    _confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in both password fields'),
                    ),
                  );
                  return;
                }
                
                if (_passwordController.text.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password must be at least 8 characters long'),
                    ),
                  );
                  return;
                }

                if (_passwordController.text != _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match'),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPFPPage(
                      email: widget.email,
                      username: widget.username,
                      dob: widget.dob,
                      gender: widget.gender,
                      password: _passwordController.text,

                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(117, 216, 216, 1),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.daysOne(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
