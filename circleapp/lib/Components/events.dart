import 'package:flutter/material.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 377,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: const Color.fromARGB(255, 163, 163, 163), width: 2)),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(-0.97, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 78,
                  width: 80,
                  color: Colors.white,
                  child: Image.asset('assets/Images/Github.png'),
                )),
          ),
          Align(
            alignment: AlignmentDirectional(-0.08, -0.85),
            child: Text(
              "GitHub Workshop",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.40, 0.70),
            child: Text(
              '30/11/2024',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.90, 0.80),
            child: Text(
              'New Sem Hall',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
