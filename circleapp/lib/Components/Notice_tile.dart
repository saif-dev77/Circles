// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Notice_tile extends StatelessWidget {
  final String title;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;
  final String? value;
  final List<Widget> badge;
  const Notice_tile({
    super.key,
    required this.title,
    required this.iconColor,
    required this.icon,
    required this.onTap,
    this.value,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white54,
                ),
                SizedBox(width: 10),
                Text(
                  value!,
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, bottom: 20, top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (final b in badge) ...[b],
                Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 35,
                    color: Colors.white70,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
