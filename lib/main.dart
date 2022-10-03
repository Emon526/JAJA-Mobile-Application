import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jaja/screens/auth/signin.dart';
import 'package:jaja/screens/auth/signup.dart';
import 'package:jaja/screens/profilescreen.dart';
import 'package:jaja/screens/searchuser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
        // AuthController().getuserData(uid);
      });

      // log(islogged.toString());
      // log(uid);
    } else {
      setState(() {
        islogged = false;
        uid = '';
      });

      // log(uid);
      // log(islogged.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
      },
      // home: const SignIn(),
    );
  }
}
