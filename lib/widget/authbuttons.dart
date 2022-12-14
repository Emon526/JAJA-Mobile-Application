import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Function ontap;
  final String buttonText;
  final double width;
  const AuthButton(
      {super.key,
      required this.ontap,
      required this.buttonText,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      color: const Color(0xff404040),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          ontap();
        },
        child: Container(
          alignment: Alignment.center,
          width: width,
          padding: const EdgeInsets.all(16),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
