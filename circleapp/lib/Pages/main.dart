// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:learningdart/Pages/landing_page.dart';
import 'package:learningdart/Pages/login_page.dart';

import 'package:learningdart/Pages/register_page.dart';
import 'package:learningdart/auth/auth_gate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
// supabase setup

  
  await Supabase.initialize(url: "https://hrjeqzylakwiizgqvxpv.supabase.co", anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhyamVxenlsYWt3aWl6Z3F2eHB2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIwMDgxNDEsImV4cCI6MjA0NzU4NDE0MX0.0Dzhvs_2xJh8-bmfec8iGA1EJeTgsZB5WVgWYJ9kpPY");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome Page",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      routes: {
        '/login': (context) => LoginPage(),
        
        // Add other routes here
      },
      home: AuthGate(),
    );
  }
}

class MyWelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Stack(children: [
                Positioned(
                  top: 140,
                  left: 5,
                  child: Text(
                    "Welcome,       ",
                    style:
                        GoogleFonts.daysOne(color: Colors.white, fontSize: 45),
                  ),
                ),
                Positioned(
                  top: 190,
                  left: 10,
                  child: Text(
                    "User      ",
                    style: GoogleFonts.daysOne(
                        color: const Color.fromRGBO(117, 216, 216, 1),
                        fontSize: 25),
                  ),
                )
              ]),
            ),
            Expanded(
              flex: 5,
              child: Container(
                  height: 120,
                  width: 450,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: Stack(children: [
                    Center(
                      child: DottedBorder(
                        borderType: BorderType.Circle,
                        dashPattern: [4, 10],
                        strokeWidth: 6,
                        radius: Radius.circular(10),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Container(
                          width: 280,
                          height: 350,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 110,
                      left: 21,
                      height: 100,
                      width: 100,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(117, 216, 216, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 153,
                      height: 100,
                      width: 100,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(117, 216, 216, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 110,
                      left: 275,
                      height: 100,
                      width: 100,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(117, 216, 216, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 256,
                      left: 60,
                      height: 100,
                      width: 100,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(117, 216, 216, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 256,
                      left: 240,
                      height: 100,
                      width: 100,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(117, 216, 216, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ])),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 100,
                color: const Color.fromARGB(255, 0, 0, 0),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 42,
                      height: 50,
                      width: 140,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1, left: 1),
                          child: Text(
                            "Login",
                            style: GoogleFonts.daysOne(
                                color: Colors.black, fontSize: 19),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 230,
                      height: 50,
                      width: 140,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1, left: 1),
                          child: Text(
                            "Register",
                            style: GoogleFonts.daysOne(
                                color: Colors.black, fontSize: 19),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
