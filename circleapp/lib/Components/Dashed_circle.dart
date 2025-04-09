import 'package:flutter/material.dart';
import 'dart:math'; // For pi and radians

// Custom painter to create a dashed ring
class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    double dashWidth = 5;
    double dashSpace = 10;
    double radius = size.width / 2;
    double circumference = 2 * pi * radius;
    int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    Path path = Path();
    for (int i = 0; i < dashCount; i++) {
      double startAngle = i * (dashWidth + dashSpace) / radius;
      path.addArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        dashWidth / radius,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RotatingDashedCircle extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;

  RotatingDashedCircle({required this.hintText, required this.onChanged});

  @override
  _RotatingDashedCircleState createState() => _RotatingDashedCircleState();
}

class _RotatingDashedCircleState extends State<RotatingDashedCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Initialize rotation animation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Duration for a full rotation
    )..repeat(); // Repeats the animation
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Rotating dashed ring
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * pi, // Full rotation
                  child: CustomPaint(
                    size: Size(250, 250), // Size of the dashed ring
                    painter: DashedCirclePainter(),
                  ),
                );
              },
            ),
            // Input field inside the ring
            Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: widget.onChanged,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
