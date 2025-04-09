import 'package:flutter/material.dart';
import 'package:learningdart/Components/Notice_Badge_Urgent.dart';
import 'package:learningdart/Components/Notice_Badge_Info.dart';

import 'package:learningdart/Components/Notice_badge_event.dart';
import 'package:learningdart/Components/Notice_tile.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({super.key});

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          title: Text('Notices',
              style: TextStyle(
                  fontFamily: 'Daysone',
                  fontSize: 25,
                  color: Color.fromRGBO(117, 216, 216, 1))),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Notice_tile(
              title:
                  'Computer Science Dept. is organizing Workshop on Git and GitHub',
              iconColor: Colors.white70,
              icon: Icons.event,
              value: '21 Oct,2024',
              onTap: () {},
              badge: [NoticeBadgeEvent(), NoticeBadgeInfo()],
            ),
            const SizedBox(height: 15),
            Notice_tile(
              title: 'A talk with Professor Rajinder Dudrah',
              iconColor: Colors.white70,
              icon: Icons.event,
              value: '21 Oct,2024',
              onTap: () {},
              badge: [NoticeBadgeEvent()],
            ),
            const SizedBox(height: 15),
            Notice_tile(
              title: 'Holiday Notice',
              iconColor: Colors.white70,
              icon: Icons.event,
              value: '16 Oct,2024',
              onTap: () {},
              badge: [NoticeBadgeEvent(), NoticeBadgeInfo()],
            ),
            const SizedBox(height: 15),
            Notice_tile(
              title:
                  'Notice regarding commerce department subjects and their subjects',
              iconColor: Colors.white70,
              icon: Icons.event,
              value: '24 Oct,2024',
              onTap: () {},
              badge: [NoticeBadgeUrgent()],
            ),
            const SizedBox(height: 15),
            Notice_tile(
              title:
                  'Computer Science Dept. is organizing Workshop on Git and GitHub',
              iconColor: Colors.white70,
              icon: Icons.event,
              value: '24 Oct,2024',
              onTap: () {},
              badge: [NoticeBadgeEvent(), NoticeBadgeInfo()],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
