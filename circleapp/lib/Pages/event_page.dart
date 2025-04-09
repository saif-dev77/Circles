import 'package:flutter/material.dart';
import 'package:learningdart/Components/event_posts.dart';
import 'package:learningdart/Components/events.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
        backgroundColor: Colors.black,
        title: Text(
          'Events',
          style: TextStyle(
              fontFamily: 'Daysone',
              fontSize: 25,
              color: Color.fromRGBO(117, 216, 216, 1)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(
              height: 15,
            ),
            EventPosts(),
            SizedBox(
              height: 20,
            ),
            Events(),
          ],
        ),
      ),
    );
  }
}
