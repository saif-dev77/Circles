import 'package:flutter/material.dart';

class EventPosts extends StatelessWidget {
  const EventPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  'Upcoming',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Daysone',
                      fontSize: 20,
                      color: Color.fromRGBO(117, 216, 216, 1)),
                ),
              )),
          VerticalDivider(
            color: Colors.white,
            width: 1,
            thickness: 2,
          ),
          SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  'Registered',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Daysone',
                      fontSize: 20,
                      color: Color.fromRGBO(117, 216, 216, 1)),
                ),
              )),
        ],
      ),
    );
  }
}
