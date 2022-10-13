// import 'dart:developer';
import 'package:flutter/material.dart';
import '../../services/authservice.dart';
import '../../widget/authbuttons.dart';
import '../../widget/inputfield.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static const routeName = "/SignInScreen";

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
      const snackbar = SnackBar(
        content: Text("Invalid Information"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      // log('Form is invalid');
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
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: AuthButton(
                    ontap: () {
                      validateAndLogin();
                    },
                    buttonText: "LOG IN",
                    width: size.width,
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/ForgotPassword');
                    },
                    child: const Text(
                      "Forgot Password??",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Doesn't have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/SignUpScreen');
                      },
                      child: const Text(
                        "Sign up",
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
