import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/signupmodel.dart';
import '../screens/auth/signin.dart';
import '../screens/profilescreen.dart';

class AuthController {
  var firestore = FirebaseFirestore.instance;
  var firebaseAuth = FirebaseAuth.instance;

  void signOut() async {
    await firebaseAuth.signOut();
  }

  void loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          const snackbar = SnackBar(
            content: Text("SIGN In Succesful.enjoy"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          );
        });
        log('login Success');
      } else {
        log("Input all fill");
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  void registerUser(
      {required String firstname,
      required String email,
      required String password,
      required String lastname,
      required String phone,
      required BuildContext context}) async {
    try {
      if (firstname.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          lastname.isNotEmpty &&
          phone.isNotEmpty) {
        //save out user to auth and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        SignUpModel user = SignUpModel(
          firstname: firstname,
          lastname: lastname,
          email: email,
          phone: phone,
          password: password,
          uid: cred.user!.uid,
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson())
            .then((value) {
          const snackbar = SnackBar(
            content: Text("SIGN UP Succesful.please log in"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignIn(),
            ),
          );
        });
      } else {
        log("Input all fill");
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
