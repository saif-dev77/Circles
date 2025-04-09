import 'package:flutter/material.dart';

class OurProfileStats extends StatelessWidget {
  final String followers;
  final String following;

  const OurProfileStats({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Following
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              following,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Following',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        // Followers
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              followers,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Followers',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
