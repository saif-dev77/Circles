import 'package:flutter/material.dart';

class ForwardButton extends StatelessWidget {
  final Function() onTap;
  const ForwardButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 50,
          height: 50,
          child: const Icon(
            Icons.chevron_right,
            color: Colors.white70,
            size: 40,
          ),
        ));
  }
}
