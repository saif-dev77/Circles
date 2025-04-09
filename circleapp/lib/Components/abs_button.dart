import 'package:flutter/material.dart';

class AbsButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  const AbsButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.tealAccent,
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )),
      child: child,
    );
  }
}
