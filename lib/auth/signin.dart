import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/authbuttons.dart';
import '../widget/inputfield.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: const Color(0xff40039B),
        elevation: 0,
        title: const Text(
          'JAJA',
        ),
      ),
      body: Container(
        color: const Color(0xff90fc63),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'SIGN IN',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              inputAction: TextInputAction.next,
              controller: emailController,
              icon: Icons.person_outline,
              labelText: 'Email',
            ),
            const SizedBox(
              height: 20,
            ),
            InputField(
              inputAction: TextInputAction.done,
              controller: passwordController,
              icon: Icons.lock,
              labelText: 'Password',
              isObsecured: true,
              isPass: true,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: AuthButton(
                ontap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignIn()));
                },
                buttonText: "LOG IN",
                width: size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
