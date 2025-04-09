import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(
            20,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'MO',
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
              Text(
                'TU',
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
              Text(
                'WE',
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
              Text(
                'TH',
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
              Text(
                'FR',
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
              Text(
                'ST',
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
              Text(
                'SN',
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '02',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '03',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '04',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '05',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '06',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '07',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '08',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.circle,
                size: 0,
                color: Color.fromRGBO(117, 216, 216, 1),
              ),
              Icon(
                Icons.circle,
                size: 0,
                color: Color.fromRGBO(117, 216, 216, 1),
              ),
              Icon(
                Icons.circle,
                size: 10,
                color: Color.fromRGBO(117, 216, 216, 1),
              ),
              Icon(
                Icons.circle,
                size: 0,
                color: Color.fromRGBO(117, 216, 216, 1),
              ),
              Icon(
                Icons.circle,
                size: 0,
                color: Color.fromRGBO(117, 216, 216, 1),
              ),
              Icon(
                Icons.circle,
                size: 0,
                color: Color.fromRGBO(117, 216, 216, 1),
              ),
              Icon(
                Icons.circle,
                size: 0,
                color: Color.fromRGBO(117, 216, 216, 1),
              ),
            ],
          )
        ],
      ),
    );
  }
}
