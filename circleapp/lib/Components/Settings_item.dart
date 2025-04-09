// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:learningdart/Components/forward_button.dart';

class Settings_item extends StatelessWidget {
  final String title;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;
  final String? value;
  const Settings_item({
    super.key,
    required this.title,
    required this.iconColor,
    required this.icon,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 40,
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          value != null
              ? Text(
                  value!,
                  style: const TextStyle(fontSize: 16, color: Colors.white38),
                )
              : const SizedBox(width: 10),
          ForwardButton(
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
