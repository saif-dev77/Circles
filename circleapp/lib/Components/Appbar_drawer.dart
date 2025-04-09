import 'package:flutter/material.dart';
import 'package:learningdart/Components/My_list_tile.dart';
import 'package:learningdart/auth/auth_service.dart';
import 'package:learningdart/pages/event_page.dart';
import 'package:learningdart/pages/profile_page.dart';
import 'package:learningdart/pages/settings_page.dart';

class AppbarDrawer extends StatefulWidget {
  const AppbarDrawer({
    super.key,
  });

  @override
  State<AppbarDrawer> createState() => _AppbarDrawerState();
}

class _AppbarDrawerState extends State<AppbarDrawer> {

  final authservice = AuthService();

  void logout() async{
    await authservice.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 72, 151, 151),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // header
            Column(children: [
              DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Color.fromRGBO(214, 205, 205, 1),
                  size: 75,
                ),
              ),
              // Profile list tyle
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ));
                  },
                  child: MyListTile(
                    icon: Icons.person_3_rounded,
                    text: 'Profile',
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventPage(),
                        ));
                  },
                  child: MyListTile(
                    icon: Icons.event,
                    text: 'Events',
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventPage(),
                        ));
                  },
                  child: MyListTile(
                    icon: Icons.assignment_outlined,
                    text: 'Notices',
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                },
                child: MyListTile(icon: Icons.settings, text: 'Settings'),
              )
            ]),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: logout,
                child: MyListTile(icon: Icons.logout, text: 'Logout'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
