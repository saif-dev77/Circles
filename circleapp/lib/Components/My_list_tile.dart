// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const MyListTile({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 25, top: 15),
        child: ListTile(
          leading: Icon(
            icon,
            color: Color.fromRGBO(214, 205, 205, 1),
            size: 30,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: Color.fromRGBO(214, 205, 205, 1),
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'Daysone',
            ),
          ),
        ));
  }
}
