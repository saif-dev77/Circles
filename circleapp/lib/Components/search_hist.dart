// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Searchhistory extends StatelessWidget {
  final List username;
  final List userpfp;
  const Searchhistory(
      {super.key, required this.username, required this.userpfp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Recent Searches",
              style:
                  GoogleFonts.daysOne(color: Colors.tealAccent, fontSize: 20),
            ),
            Icon(
              Icons.trending_up,
              color: Colors.tealAccent,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 300,
          width: double.infinity,
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, Index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(userpfp[Index]),
                    radius: 25,
                  ),
                  title: Text(
                    username[Index],
                    style:
                        GoogleFonts.daysOne(color: Colors.white, fontSize: 13),
                  ),
                  trailing: Icon(
                    Icons.clear,
                    color: Colors.tealAccent,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
