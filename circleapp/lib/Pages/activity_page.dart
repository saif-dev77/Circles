import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Components/Activity_bar.dart';
import 'package:learningdart/blocs/activity_bloc.dart';

import 'package:learningdart/Pages/recieved_req_page.dart';
import 'package:learningdart/pages/sent_requests_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late ActivityBloc _activityBloc;

  @override
  void initState() {
    super.initState();
    _activityBloc = ActivityBloc();
    _activityBloc.add(LoadNotifications());
  }

  @override
  void dispose() {
    _activityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _activityBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: AppBar(
            iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
            backgroundColor: Colors.black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Activity',
                style: TextStyle(
                  fontFamily: 'Daysone',
                  fontSize: 40,
                  color: Color.fromRGBO(117, 216, 216, 1),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SentRequestsPage(),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white38, width: 4),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15)),
                        height: 120,
                        width: 130,
                        child: Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          'Sent Requests',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecievedReqPage(),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white38, width: 4),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15)),
                        height: 120,
                        width: 130,
                        child: Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          'Recieved Requests',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.trending_up_outlined,
                    color: Colors.white70,
                    size: 50,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Last 7 Days',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Divider(),
              
              // Notifications list with BLoC
              Expanded(
                child: BlocBuilder<ActivityBloc, ActivityState>(
                  builder: (context, state) {
                    if (state is ActivityLoading) {
                      return Center(child: CircularProgressIndicator(
                        color: Color.fromRGBO(117, 216, 216, 1),
                      ));
                    } else if (state is ActivityLoaded) {
                      final notifications = state.notifications;
                      
                      if (notifications.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 70,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No activity yet',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ActivityBloc>().add(LoadNotifications());
                        },
                        color: Color.fromRGBO(117, 216, 216, 1),
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            
                            return GestureDetector(
                              onTap: () {
                                // Mark notification as read when tapped
                                if (notification['is_read'] == false) {
                                  context.read<ActivityBloc>().add(
                                    MarkNotificationAsRead(notification['id'])
                                  );
                                }
                              },
                              child: ActivityBar(
                                notification: notification,
                                onTap: () {
                                  // Mark notification as read when tapped
                                  if (notification['is_read'] == false) {
                                    context.read<ActivityBloc>().add(
                                      MarkNotificationAsRead(notification['id'])
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is ActivityError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
