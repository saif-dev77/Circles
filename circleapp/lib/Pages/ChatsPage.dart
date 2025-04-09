import 'package:flutter/material.dart';
import 'package:learningdart/Components/Chattab.dart';

class Chatspage extends StatelessWidget {
  const Chatspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(children: [
            Text(
              ' Chats',
              style: TextStyle(
                fontFamily: 'Daysone',
                color: Color.fromRGBO(117, 216, 216, 1),
                fontSize: 50,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white54, Colors.black]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.black),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'All',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 20),
                              ),
                              Text(
                                'Teachers',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 20),
                              ),
                              Text(
                                'Req',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 20),
                              )
                            ],
                          )),
                    ))),
            Chattab(
                pfp: 'assets/Images/sushantpfp.jpg',
                status: 'Seen 30m ago',
                username: 'sussy_sushi'),
            SizedBox(
              height: 20,
            ),
            Chattab(
                pfp: 'assets/Images/mayankpfp.jpg',
                status: 'Arcane dekhi ?',
                username: 'Mighty_mayank'),
            SizedBox(
              height: 20,
            ),
            Chattab(
                pfp: 'assets/Images/harshpfp.jpg',
                status: 'sent',
                username: 'harsh_banda_wala'),
            SizedBox(
              height: 20,
            ),
            Chattab(
                pfp: 'assets/Images/aayushpfp.jpg',
                status: 'New 3 Messages',
                username: 'KD_01')
          ])),
    );
  }
}
