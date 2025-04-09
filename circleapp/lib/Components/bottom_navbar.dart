import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class MyBottomnavbar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomnavbar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return GNav(
        onTabChange: (value) => onTabChange!(value),
        haptic: true,
        color: const Color.fromARGB(255, 104, 104, 104),
        activeColor: const Color.fromARGB(255, 203, 203, 203),
        iconSize: 30,
        duration: Duration(milliseconds: 600),
        tabs: const [
          GButton(
            icon: Icons.home_outlined,
          ),
          GButton(
            icon: Icons.search_rounded,
          ),
          GButton(
            icon: Icons.add_a_photo_outlined,
          ),
          GButton(
            icon: Icons.menu_book_sharp,
          )
        ]);
  }
}
