import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  var firestore = FirebaseFirestore.instance;
  var firebaseAuth = FirebaseAuth.instance;

  void signOut(BuildContext context) async {
    Navigator.pushReplacementNamed(context, '/SignInScreen');
    await firebaseAuth.signOut();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
  }

  void loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          const snackbar = SnackBar(
            content: Text("SIGN In Succesful.enjoy"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/SearchUserScreen');

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('uid', firebaseAuth.currentUser!.uid);
        });

        // log(firebaseAuth.currentUser!.uid);
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

        UserModel user = UserModel(
            firstname: firstname,
            lastname: lastname,
            email: email,
            phone: phone,
            password: password,
            uid: cred.user!.uid,
            profilePhoto: '',
            followers: [],
            following: [],
            recordings: []);
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson())
            .then((value) {
          const snackbar = SnackBar(
            content: Text("SIGN UP Succesful.please log in"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          Navigator.pushNamed(context, '/SignInScreen');
        });
      } else {
        log("Input all fill");
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  void followuser({required String followeruid}) async {
    // add the uid into followers list of that user
    final followersdata =
        await firestore.collection('users').doc(followeruid).get();
    List followers = followersdata.get('followers');
    followers.add(firebaseAuth.currentUser!.uid);

    UserModel user = UserModel(
        firstname: followersdata.get('firstname'),
        lastname: followersdata.get('lastname'),
        email: followersdata.get('email'),
        phone: followersdata.get('phone'),
        password: followersdata.get('password'),
        uid: followersdata.get('uid'),
        profilePhoto: followersdata.get('profilePhoto'),
        followers: followers,
        following: followersdata.get('following'),
        recordings: followersdata.get('recordings'));
    await firestore.collection('users').doc(followeruid).set(user.toJson());
    // log(user.toJson().toString());

    // add following  uid into current user

    final followingdata = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();

    List following = followingdata.get('following');
    following.add(followeruid);
    // log(following.toString());

    UserModel currentuser = UserModel(
      firstname: followingdata.get('firstname'),
      lastname: followingdata.get('lastname'),
      email: followingdata.get('email'),
      phone: followingdata.get('phone'),
      password: followingdata.get('password'),
      uid: followingdata.get('uid'),
      profilePhoto: followingdata.get('profilePhoto'),
      followers: followingdata.get('followers'),
      following: following,
      recordings: followingdata.get('recordings'),
    );

    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set(currentuser.toJson());
    // log(currentuser.toJson().toString());
  }

  void unfollowuser({required String followeruid}) async {
    // remove the uid from followers list of that user
    final followersdata =
        await firestore.collection('users').doc(followeruid).get();
    List followers = followersdata.get('followers');
    followers.remove(firebaseAuth.currentUser!.uid);

    UserModel user = UserModel(
      firstname: followersdata.get('firstname'),
      lastname: followersdata.get('lastname'),
      email: followersdata.get('email'),
      phone: followersdata.get('phone'),
      password: followersdata.get('password'),
      uid: followersdata.get('uid'),
      profilePhoto: followersdata.get('profilePhoto'),
      followers: followers,
      following: followersdata.get('following'),
      recordings: followersdata.get('recordings'),
    );
    await firestore.collection('users').doc(followeruid).set(user.toJson());
    // log(user.toJson().toString());

    // add following  uid into current user

    final followingdata = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();

    List following = followingdata.get('following');
    following.remove(followeruid);
    // log(following.toString());

    UserModel currentuser = UserModel(
      firstname: followingdata.get('firstname'),
      lastname: followingdata.get('lastname'),
      email: followingdata.get('email'),
      phone: followingdata.get('phone'),
      password: followingdata.get('password'),
      uid: followingdata.get('uid'),
      profilePhoto: followingdata.get('profilePhoto'),
      followers: followingdata.get('followers'),
      following: following,
      recordings: followingdata.get('recordings'),
    );

    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set(currentuser.toJson());
    // log(currentuser.toJson().toString());
  }

  resetPassword({required String email, required BuildContext context}) {
    try {
      firebaseAuth.sendPasswordResetEmail(email: email);
      final snackbar = SnackBar(
        duration: Duration(seconds: 8),
        content:
            Text("Email sent.Please check Inbox.Don't forgot to check spam"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.pushNamed(context, '/SignInScreen');
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
