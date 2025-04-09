import 'package:flutter/material.dart';
import 'package:learningdart/Components/FollowReqTabs.dart';

class RecievedReqPage extends StatelessWidget {
  const RecievedReqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              'Follow Requests',
              style: TextStyle(
                  color: Color.fromRGBO(117, 216, 216, 1),
                  fontSize: 40,
                  fontFamily: 'Daysone'),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'From:',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
            Column(children: [Divider()]),
            SizedBox(
              height: 15,
            ),
            Followreqtabs(
                username: 'Gaurav_Langotia',
                pfp: 'assets/Images/gauravpfp.jpg'),
            SizedBox(
              height: 20,
            ),
            Followreqtabs(
                username: 'Hars_Banda_Wala', pfp: 'assets/Images/harshpfp.jpg'),
          ],
        ),
      ),
    );
  }
}
