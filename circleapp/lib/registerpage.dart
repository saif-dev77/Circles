// ignore_for_file: camel_case_types, avoid_unnecessary_containers

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Pages/home_page.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
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
                left: 74,
                child: Container(
                  height: 270,
                  width: 270,
                  
                  
                  decoration: BoxDecoration(
                    
      
                      color: Color.fromRGBO(117, 216, 216, 1),
                      shape: BoxShape.circle),
                
                    child: SizedBox(
                      width: 100,
                      
                      child: Padding(
                        padding: const EdgeInsets.only(top: 105, left: 15, right: 15),
                        
                        

                        child: TextField(
                          decoration: InputDecoration(
                            
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Your Email",
                            hintStyle: GoogleFonts.daysOne(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5), fontSize: 15, ),
                            
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black,width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black,width: 2),
                            )
                            
                          ),
                        ),
                      ),
                    ),
            ),),
            Positioned(
                top: 730,
                left: 155,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.arrow_right_alt_sharp,
                    size: 50,
                    color: Colors.black,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
