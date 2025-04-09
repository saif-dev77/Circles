import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Pages/passwordpage.dart';
import 'package:learningdart/Pages/postpfppage.dart';

class GenderandDOB extends StatefulWidget {
  final String username;
  final String email;

  const GenderandDOB({super.key, required this.email, required this.username});

  @override
  State<GenderandDOB> createState() => _GenderandDOBState();
}

class _GenderandDOBState extends State<GenderandDOB> {
  // Add new controller and variables
  final TextEditingController _dobController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female'];

  // Add date picker function
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // Set a default initial date
      firstDate: DateTime(1900), // Reasonable minimum date
      lastDate: DateTime.now(), // Current date as maximum
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format date as DD-MM-YYYY
        _dobController.text = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";

        // Calculate age
        int age = DateTime.now().year - picked.year;
        if (DateTime.now().month < picked.month || (DateTime.now().month == picked.month && DateTime.now().day < picked.day)) {
          age--;
        }

        // Show snackbar if age is not 17
        if (age < 17) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your age is $age. You must be 17 years old.'),
            ),
          );
        }
      });
    }
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
                )),
          ),
          Positioned(
            top: 130,
            left: 8,
            child: Text(
              "Enter",
              style: GoogleFonts.daysOne(
                  color: Color.fromRGBO(117, 216, 216, 1), fontSize: 45),
            ),
          ),
          Positioned(
            top: 170,
            left: 8,
            child: Text(
                "DOB and Gender",
                style: GoogleFonts.daysOne(color: Colors.white, fontSize: 35),
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
            left: 61,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(117, 216, 216, 1),
                  shape: BoxShape.circle),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 30),
                    child: Text(
                      'Enter Date of Birth',
                      style: GoogleFonts.daysOne(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 85, left: 15, right: 15),
                    child: TextField(
                      controller: _dobController,
                      readOnly: true, // Make the field read-only
                      onTap: _selectDate, // Open date picker on tap
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                        ),
                        hintText: "DD-MM-YYYY",
                        hintStyle: GoogleFonts.daysOne(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
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
                    padding: const EdgeInsets.only(top: 150, left: 24),
                    child: Text(
                      'Select Gender',
                      style: GoogleFonts.daysOne(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 175, left: 30, right: 40),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          isExpanded: true,
                          hint: Text(
                            'Select Gender',
                            style: GoogleFonts.daysOne(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 15,
                            ),
                          ),
                          value: _selectedGender,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                          items: _genders.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(
                                gender,
                                style: GoogleFonts.daysOne(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
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
                if (_selectedDate == null || _selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select both date of birth and gender'),
                    ),
                  );
                  return;
                }

                // Navigate with DateTime object
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordPage(
                      email: widget.email,
                      username: widget.username,
                      dob: _selectedDate,
                      gender: _selectedGender!,
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
