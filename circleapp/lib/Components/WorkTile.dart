import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Worktile extends StatelessWidget {
  final String task;
  final String quantity;
  const Worktile({super.key, required this.task, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      height: 120,
      width: 250,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                ),
                Text(
                  quantity,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Spacer(),
            IconButton(
                color: Colors.white70,
                iconSize: 40,
                onPressed: () {},
                icon: Icon(Ionicons.add_circle_outline))
          ],
        ),
      ),
    );
  }
}
