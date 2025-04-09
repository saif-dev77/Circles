import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/pages/login_page.dart';
import 'package:learningdart/pages/register_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(children: [
                  Positioned(
                    top: 140,
                    left: 5,
                    child: Text(
                      "Welcome,       ",
                      style: GoogleFonts.daysOne(
                          color: Colors.white, fontSize: 45),
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                    child: Stack(children: [
                  Center(
                    child: DottedBorder(
                      borderType: BorderType.Circle,
                      dashPattern: [3, 7],
                      strokeWidth: 2,
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
                    top: 90,
                    left: 15,
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
                    top: 1,
                    left: 145,
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
                    top: 90,
                    right: 15,
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
                    top: 240,
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
                    top: 240,
                    right: 60,
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
                        left: 35,
                        height: 50,
                        width: 145,
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
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 35,
                        height: 50,
                        width: 145,
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
                                  color: Colors.black, fontSize: 20),
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
        ));
  }
}
