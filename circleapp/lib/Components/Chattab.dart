import 'package:flutter/material.dart';

class Chattab extends StatelessWidget {
  final String username;
  final String status;
  final String pfp;
  const Chattab({
    super.key,
    required this.pfp,
    required this.status,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(pfp),
          ),
          SizedBox(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(color: Colors.white54, fontSize: 25),
              ),
              Text(
                status,
                style: TextStyle(color: Colors.white38, fontSize: 20),
              )
            ],
          ),
        ],
      ),
    );
  }
}
