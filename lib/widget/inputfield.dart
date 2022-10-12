import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final String validatortext;
  final IconData icon;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextEditingController controller;
  // final Function(String) onchanged;
  final Function? suffixonTap;

  bool isPass;
  bool isObsecured;

  InputField({
    required this.inputAction,
    this.isObsecured = false,
    super.key,
    required this.labelText,
    this.isPass = false,
    required this.icon,
    required this.controller,
    required this.validatortext,
    this.suffixonTap,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecured,
      cursorColor: const Color(0xff40039B),
      textInputAction: inputAction,
      keyboardType: inputType,
      validator: (value) {
        if (value!.isEmpty || !value.contains('')) {
          return validatortext;
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xff40039B),
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        filled: true,
        suffix: isPass
            ? InkWell(
                child: Icon(
                  isObsecured ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onTap: () {
                  suffixonTap!();
                },
              )
            : const SizedBox(),
        border: InputBorder.none,
        prefixIcon: Icon(
          icon,
          size: 24,
          color: Colors.black,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: Color(0xff40039B),
          ),
        ),
      ),
    );
  }
}
