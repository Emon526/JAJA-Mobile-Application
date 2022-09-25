import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final TextInputAction inputAction;
  final TextEditingController controller;
  bool isPass;
  bool isObsecured;
  final IconData icon;
  InputField({
    required this.inputAction,
    this.isObsecured = false,
    super.key,
    required this.labelText,
    this.isPass = false,
    required this.icon,
    required this.controller,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isObsecured,
        cursorColor: const Color(0xff40039B),
        textInputAction: widget.inputAction,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Color(0xff40039B),
          ),
          fillColor: Colors.white,
          filled: true,
          suffix: widget.isPass
              ? InkWell(
                  child: Icon(
                    widget.isObsecured
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onTap: () {
                    setState(() {
                      widget.isObsecured = !widget.isObsecured;
                    });
                  },
                )
              : const SizedBox(),
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.icon,
            size: 24,
            color: Colors.black,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.0,
              color: Color(0xff40039B),
            ),
          ),
          // enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
