import 'package:flutter/material.dart';

class Followreqtabs extends StatelessWidget {
  final String username;
  final String pfp;
  const Followreqtabs({super.key, required this.username, required this.pfp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(pfp),
          radius: 30,
        ),
        Text(
          username,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 23,
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.check,
              size: 30,
              color: Colors.white54,
            ))
      ],
    );
  }
}
