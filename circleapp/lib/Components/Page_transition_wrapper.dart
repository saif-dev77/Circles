import 'package:flutter/material.dart';
import 'Dashed_circle.dart';

class LoginFormWidget extends StatefulWidget {
  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  late PageController _pageController;
  bool isFirstPage = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (text.isNotEmpty && isFirstPage) {
      // Move to the next page after the first input
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      isFirstPage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(), // Prevent manual swipe
          children: [
            // First page: Rotating dashed circle with TextField
            RotatingDashedCircle(
              hintText: "Enter Your Email",
              onChanged: _onTextChanged,
            ),
            // Second page: Another TextField (like password)
            _buildNewTextField("Enter Your Password"),
          ],
        ),
      ),
    );
  }

  // Second page: A new container with another TextField
  Widget _buildNewTextField(String hintText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250.0,
          height: 250.0,
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ), 
            ),
          ),
        ),
      ],
    );
  }
}
