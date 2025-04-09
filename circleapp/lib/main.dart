// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, unnecessary_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learningdart/pages/landing_page.dart';


Future<void> main() async {
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
      home: LandingPage(),
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
          ],
        ),
      ),
    );
  }
}
