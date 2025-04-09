import 'package:flutter/material.dart';

class NoticeBadgeEvent extends StatelessWidget {
  const NoticeBadgeEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              'Event',
              style: TextStyle(color: Colors.orange.shade800, fontSize: 20),
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
