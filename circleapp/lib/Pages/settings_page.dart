import 'package:flutter/material.dart';
import 'package:learningdart/Components/forward_button.dart';
import 'package:learningdart/Components/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromRGBO(117, 216, 216, 1)),
          backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    ' Settings',
                    style: TextStyle(
                        fontFamily: 'Daysone',
                        fontSize: 40,
                        color: Color.fromRGBO(117, 216, 216, 1)),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.settings,
                      color: Color.fromRGBO(117, 216, 216, 1),
                      size: 40,
                    ),
                  ),
                ]),
                const SizedBox(height: 40),
                Text(
                  'Account',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white38,
                      fontSize: 24),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 60,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saifansari',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Student',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ForwardButton(
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white38),
                ),
                const SizedBox(height: 20),
                Settings_item(
                  title: 'Language',
                  icon: Icons.language,
                  iconColor: Colors.white70,
                  value: 'English',
                  onTap: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                Settings_item(
                  title: 'Notifications',
                  icon: Icons.notifications_outlined,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                Settings_item(
                  title: 'Privacy Shutter',
                  icon: Icons.lock_outline,
                  iconColor: Colors.white70,
                  value: 'Private',
                  onTap: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                Settings_item(
                  title: 'Reminders',
                  icon: Icons.lock_clock_outlined,
                  iconColor: Colors.white70,
                  value: 'On',
                  onTap: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                Settings_item(
                  title: 'Permissions',
                  icon: Icons.smartphone,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
                const SizedBox(height: 40),
                Text(
                  'Who can See You',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white38),
                ),
                const SizedBox(height: 20),
                Settings_item(
                  title: 'Batchmates',
                  icon: Icons.group_outlined,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
                const SizedBox(height: 15),
                Settings_item(
                  title: 'Crosspost',
                  icon: Icons.drag_indicator_outlined,
                  iconColor: Colors.white70,
                  value: 'On',
                  onTap: () {},
                ),
                const SizedBox(height: 15),
                Settings_item(
                  title: 'Blocked',
                  icon: Icons.block_outlined,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
                const SizedBox(height: 15),
                Settings_item(
                  title: 'Hide Stories',
                  icon: Icons.hide_image_outlined,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
                const SizedBox(height: 40),
                Text(
                  'Support',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white38),
                ),
                const SizedBox(height: 20),
                Settings_item(
                  title: 'Help Centre',
                  icon: Icons.help_center_outlined,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
                const SizedBox(height: 15),
                Settings_item(
                  title: 'About',
                  icon: Icons.info_outline,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
                const SizedBox(height: 15),
                Settings_item(
                  title: 'Report an Issue',
                  icon: Icons.report_outlined,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Support',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white38),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Resgister New',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color.fromRGBO(117, 216, 216, 1)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Add account',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color.fromRGBO(117, 216, 216, 1)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          ]),
        ));
  }
}
