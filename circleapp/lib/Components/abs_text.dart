import 'package:flutter/material.dart';

class AbsText extends StatelessWidget {
  final String displayString;
  final double fontSize;
  const AbsText(
      {super.key, required this.displayString, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      displayString,
      style: TextStyle(fontFamily: "Daysone", fontSize: fontSize),
    );
  }
}
