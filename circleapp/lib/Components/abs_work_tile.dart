
import 'package:flutter/material.dart';

class AbsWorkTile extends StatelessWidget {
  final Function()? onTap;
  final String role;
  final String org;
  const AbsWorkTile(
      {super.key, required this.role, required this.org, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const AbsAvatar(radius: 18),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AbsNormalText(displayString: role, fontSize: 15),
                      AbsNormalText(displayString: org, fontSize: 13)
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_outward)
                ],
              ),
            )));
  }
}
