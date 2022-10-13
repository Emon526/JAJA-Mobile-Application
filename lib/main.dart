import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homescreen.dart';
import 'screens/auth/forgotpassword.dart';
import 'screens/auth/signin.dart';
import 'screens/auth/signup.dart';
import 'screens/profilescreen.dart';
import 'screens/searchuser.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool islogged = false;
  String uid = '';
  @override
  void initState() {
    checkUserLogin();
    super.initState();
  }

  void checkUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('uid');
    if (userId != null) {
      setState(() {
        islogged = true;
        uid = userId;
      });
    } else {
      setState(() {
        islogged = false;
        uid = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JAJA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: islogged ? const SearchUser() : const HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        SignIn.routeName: (context) => const SignIn(),
        SignUp.routeName: (context) => const SignUp(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        SearchUser.routeName: (context) => const SearchUser(),
        ForgotPassword.routeName: (context) => const ForgotPassword(),
      },
    );
  }
}
