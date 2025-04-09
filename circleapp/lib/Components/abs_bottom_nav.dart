import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class AbsBottomNav extends StatelessWidget {
  void Function(int)? onTabChange;
  AbsBottomNav({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return GNav(
        onTabChange: (value) => onTabChange!(value),
        iconSize: 30,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        tabMargin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        tabs: const [
          GButton(
            icon: Icons.home_outlined,
            text: "Home",
          ),
          GButton(
            icon: Icons.people_outline,
            text: "Network",
          ),
          GButton(
            icon: Icons.work_outline_rounded,
            text: "Work",
          ),
          GButton(
            icon: Icons.chat_bubble_outline,
            text: "Chat",
          )
        ]);
  }
}
