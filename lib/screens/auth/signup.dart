import 'dart:developer';
import 'package:flutter/material.dart';
import '../../services/authservice.dart';
import '../../widget/authbuttons.dart';
import '../../widget/inputfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const routeName = "/SignUpScreen";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  bool passvisibility = true;
  final GlobalKey<FormState> _signupformKey = GlobalKey<FormState>();

  void validateAndSignUp() async {
    final FormState form = _signupformKey.currentState!;
    if (form.validate()) {
      log('Form is valid');
      AuthController().registerUser(
          context: context,
          firstname: _firstnameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          lastname: _lastnameController.text,
          phone: _phonenumberController.text);
    } else {
      const snackbar = SnackBar(
        content: Text("Invalid Information"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Form(
            key: _signupformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  labelText: 'First Name',
                  validatortext: "Enter First Name",
                  inputType: TextInputType.name,
                  inputAction: TextInputAction.next,
                  controller: _firstnameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  labelText: 'Last Name',
                  validatortext: "Enter Last Name",
                  inputType: TextInputType.name,
                  inputAction: TextInputAction.next,
                  controller: _lastnameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  labelText: 'Email',
                  validatortext: "Enter Email",
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  controller: _emailController,
                  icon: Icons.email,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  labelText: 'Phone Number',
                  validatortext: "Enter Phone Number",
                  inputType: TextInputType.phone,
                  inputAction: TextInputAction.next,
                  controller: _phonenumberController,
                  icon: Icons.phone,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  validatortext: 'Enter Password',
                  inputType: TextInputType.visiblePassword,
                  suffixonTap: () {
                    setState(() {
                      passvisibility = !passvisibility;
                    });
                  },
                  inputAction: TextInputAction.next,
                  controller: _passwordController,
                  icon: Icons.lock,
                  labelText: 'Password',
                  isObsecured: passvisibility,
                  isPass: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  validatortext: 'Enter Confirm Password',
                  inputType: TextInputType.visiblePassword,
                  suffixonTap: () {
                    setState(() {
                      passvisibility = !passvisibility;
                    });
                  },
                  inputAction: TextInputAction.done,
                  controller: _confirmpasswordController,
                  icon: Icons.lock,
                  labelText: 'Confirm Password',
                  isObsecured: passvisibility,
                  isPass: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthButton(
                  ontap: () {
                    validateAndSignUp();
                  },
                  buttonText: "SIGN UP",
                  width: size.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/SignInScreen');
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
