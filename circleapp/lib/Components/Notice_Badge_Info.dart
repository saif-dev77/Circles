import 'package:flutter/material.dart';

class NoticeBadgeInfo extends StatelessWidget {
  const NoticeBadgeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              'Info',
              style: TextStyle(color: Colors.blue.shade800, fontSize: 20),
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
