// ignore_for_file: camel_case_types, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:learningdart/Components/Calendar.dart';

import 'package:learningdart/Components/WorkTile.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _workspacepagestate();
}

class _workspacepagestate extends State<WorkspacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'CS (H)',
          style: TextStyle(
              fontFamily: 'Daysone', color: Colors.white, fontSize: 40),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Ionicons.notifications_outline,
                  size: 35,
                )),
          ),
        ],
        iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(children: [
          Container(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    Worktile(
                      task: 'Assignments',
                      quantity: ' 2',
                    ),
                    SizedBox(width: 20),
                    Worktile(
                      task: 'Notes',
                      quantity: ' 5',
                    ),
                    SizedBox(width: 20),
                    Worktile(
                      task: 'Notices For You',
                      quantity: ' 1',
                    ),
                    SizedBox(width: 20),
                    Worktile(
                      task: 'Registered Events',
                      quantity: ' 3',
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white54, Colors.black]),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subjects :',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'GE',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 30),
                                  ),
                                  Text(
                                    'SEC',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 30),
                                  ),
                                  Text(
                                    'VAC',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 30),
                                  )
                                ]),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Indian English Literatre',
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Document Prepration and presentation',
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Culture and Communication',
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Table:',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(
                  height: 20,
                ),
                Calendar(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Wednesday 04',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                                color: Colors.white70,
                                onPressed: () {},
                                icon: Icon(Ionicons.arrow_back_outline)),
                            IconButton(
                                color: Colors.white70,
                                onPressed: () {},
                                icon: Icon(Ionicons.arrow_forward_outline)),
                          ],
                        ),
                        Column(children: [Divider()]),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '08:00-09:00',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      'AM',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 15),
                                    )
                                  ],
                                ),
                                Text(
                                  'AADS',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '11:00-12:00',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      'AM',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 15),
                                    ),
                                  ],
                                ),
                                Text(
                                  'GE',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '12:00-01:00',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      'PM',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 15),
                                    ),
                                  ],
                                ),
                                Text(
                                  'DSE',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '01:00-02:00',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      'PM',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 15),
                                    ),
                                  ],
                                ),
                                Text(
                                  'TOC',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '02:00-04:00',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      'PM',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 15),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Software Eng',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
