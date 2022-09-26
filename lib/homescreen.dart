import 'package:flutter/material.dart';

import 'screens/auth/signin.dart';
import 'screens/auth/signup.dart';
import 'widget/authbuttons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff90fc63),
      appBar: AppBar(
        backgroundColor: const Color(0xff40039B),
        elevation: 0,
        title: const Text(
          'JAJA',
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'JAJA',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Icon(
              Icons.keyboard_voice_outlined,
              size: 180,
            ),
            const SizedBox(
              height: 60,
            ),
            AuthButton(
              ontap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              buttonText: "SIGN IN",
              width: size.width,
            ),
            const SizedBox(
              height: 10,
            ),
            AuthButton(
              ontap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
              buttonText: "SIGN UP",
              width: size.width,
            ),
          ],
        ),
      ),
    );
  }
}
