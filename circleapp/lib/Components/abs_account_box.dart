
import 'package:flutter/material.dart';
import 'package:learningdart/Components/abs_button.dart';
import 'package:learningdart/Components/abs_text.dart';

class AbsAccountBox extends StatelessWidget {
  final String accountName;
  final String buttonText;
  final String userpfp;
  const AbsAccountBox(
      {super.key, required this.accountName, required this.buttonText, required this.userpfp});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
              minWidth: 150, minHeight: 200, maxWidth: 150, maxHeight: 200),
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(117, 216, 216, 1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12)),
              
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage("assets/Images/saifpfp.jpg"),
                radius: 30),
              const SizedBox(height: 15),
              AbsText(displayString: accountName, fontSize: 14),
              const SizedBox(
                height: 15,
              ),
              AbsButton(
                  onPressed: () {},
                  child: AbsText(displayString: buttonText, fontSize: 16))
            ],
          )),
    );
  }
}
