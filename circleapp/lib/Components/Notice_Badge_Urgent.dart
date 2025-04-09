import 'package:flutter/material.dart';

class NoticeBadgeUrgent extends StatelessWidget {
  const NoticeBadgeUrgent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              'Urgent',
              style: TextStyle(color: Colors.red.shade800, fontSize: 20),
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
