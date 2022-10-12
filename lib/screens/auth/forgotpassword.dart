import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jaja/services/authservice.dart';
import '../../widget/authbuttons.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  static const routeName = "/ForgotPassword";

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();

  void validateAndLogin() async {
    final FormState form = _loginformKey.currentState!;
    if (form.validate()) {
      AuthController().resetPassword(
        email: _emailController.text,
        context: context,
      );
    } else {
      log('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff90fc63),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: const Color(0xff40039B),
        elevation: 0,
        title: const Text(
          'JAJA',
        ),
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/SignInScreen');
          },
          // child: const Text(
          //   "Go for Sign in",
          //   style: TextStyle(
          //     color: Colors.red,
          //     fontSize: 16,
          //   ),
          // ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 50,
          ),
          child: Form(
            key: _loginformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'JAJA',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_voice_outlined,
                      size: 80,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  cursorColor: const Color(0xff40039B),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    String pattern =
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?)*$";
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value!) || value.isEmpty) {
                      return 'Enter a valid email address';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Color(0xff40039B),
                      fontWeight: FontWeight.w500,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.email,
                      size: 24,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: Color(0xff40039B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: AuthButton(
                    ontap: () {
                      validateAndLogin();
                    },
                    buttonText: "Send Email",
                    width: size.width,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.abc),
      // ),
    );
  }
}
