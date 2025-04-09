import 'package:flutter/material.dart';

import 'package:learningdart/Components/bottom_navbar.dart';
import 'package:learningdart/Pages/createpost_page.dart';

import 'package:learningdart/Pages/home_page.dart';
import 'package:learningdart/Pages/search_page.dart';
import 'package:learningdart/Pages/workspace_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({
    super.key,
  });

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final List<dynamic> pages = [
    const HomePage(),
    const SearchPage(),
    const CreatePostPage(),
    const WorkspacePage(),
  ];

  int actualPageIndex = 0;

  void navigateBottomBar(index) {
    setState(() {
      actualPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: pages[actualPageIndex],
        ),
        bottomNavigationBar:
            MyBottomnavbar(onTabChange: (index) => navigateBottomBar(index)),
      ),
    );
  }
}
