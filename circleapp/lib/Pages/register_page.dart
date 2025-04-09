import 'dart:math';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:learningdart/Pages/register_details.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  bool _isOtpSent = false;
  String _generatedOtp = '';

  // Function to generate a random 6-digit OTP
  String _generateOtp() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  // Function to send OTP via SendGrid
  Future<void> sendOtp(String email) async {
    _generatedOtp = _generateOtp(); // Generate OTP

    // SendGrid API endpoint
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');

    // Email body
    final emailBody = {
      "personalizations": [
        {
          "to": [
            {"email": email}
          ],
          "subject": "Your OTP Code"
        }
      ],
      "from": {"email": "sushantkumarcs22@pgdav.du.ac.in"},
      "content": [
        {
          "type": "text/plain",
          "value": "Your OTP code is $_generatedOtp. It is valid for 10 minutes."
        }
      ]
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer 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",
          "Content-Type": "application/json"
        },
        body: json.encode(emailBody),
      );

      if (response.statusCode == 202) {
        setState(() {
          _isOtpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent to your email.')),
        );
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to validate the email and send OTP
  void checkEmail() {
    final email = _emailController.text.trim();

    // Validate the email domain
    if (!email.endsWith('@pgdav.du.ac.in')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only @pgdav.du.ac.in emails are allowed.')),
      );
      return;
    }

    // Send OTP if email is valid
    sendOtp(email);

    // Open the OTP dialog for the user to enter OTP
    showOtpDialog();
  }

  // Function to show OTP dialog
  void showOtpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _otpController = TextEditingController();

        return AlertDialog(
          title: Text("Enter OTP"),
          content: TextField(
            controller: _otpController,
            decoration: InputDecoration(
              hintText: "Enter OTP sent to your email",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final enteredOtp = _otpController.text.trim();
                if (enteredOtp == _generatedOtp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('OTP verified successfully.')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetails(
                        email: _emailController.text.trim(),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid OTP. Please try again.')),
                  );
                  Navigator.pop(context); // Close dialog
                }
              },
              child: Text("Verify"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
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
                  "Register          ",
                  style: GoogleFonts.daysOne(color: Colors.white, fontSize: 50),
                ),
              ),
            ),
            Positioned(
              top: 205,
              left: 10,
              child: Container(
                height: 80,
                color: const Color.fromARGB(0, 0, 0, 0),
                child: Text(
                  "Here                                      ",
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
                      child: Text('Enter your College email', style: GoogleFonts.daysOne(color: Colors.black, fontSize: 14, ),),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 105, left: 15, right: 15),
                      child: TextField(
                        controller: _emailController,
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
                    
                  ],
                ),
              ),
            ),
            Align(
                alignment: AlignmentDirectional(0, 0.75),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 10,
                    animationDuration: Duration(seconds: 1),
                    shadowColor: Colors.tealAccent
                  ),
                  onPressed: () {
                    checkEmail();
                  },
                  child: Text(
                    'Check Email',
                    style:
                        GoogleFonts.daysOne(color: Colors.black, fontSize: 20),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}


