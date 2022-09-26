import 'dart:developer';
import 'package:flutter/material.dart';
import '../../services/authservice.dart';
import '../../widget/authbuttons.dart';
import '../../widget/inputfield.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passvisibility = true;
  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();

  void validateAndLogin() async {
    final FormState form = _loginformKey.currentState!;
    if (form.validate()) {
      AuthController().loginUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      log('Form is invalid');
    }
  }

  @override
  void initState() {
    _emailController.text = 'emn@gmail.com';
    _passwordController.text = '123456';

    super.initState();
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
                  labelText: 'Email',
                  validatortext: "Enter Email Address",
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  controller: _emailController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  validatortext: 'Enter Password',
                  inputType: TextInputType.visiblePassword,
                  suffixonTap: () {
                    setState(() {
                      passvisibility = !passvisibility;
                    });
                  },
                  inputAction: TextInputAction.done,
                  controller: _passwordController,
                  icon: Icons.lock,
                  labelText: 'Password',
                  isObsecured: passvisibility,
                  isPass: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: AuthButton(
                    ontap: () {
                      validateAndLogin();
                    },
                    buttonText: "LOG IN",
                    width: size.width,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
