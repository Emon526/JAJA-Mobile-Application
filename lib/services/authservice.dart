import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import '../../models/signupmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  var firestore = FirebaseFirestore.instance;
  var firebaseAuth = FirebaseAuth.instance;

  void signOut() async {
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

        log(firebaseAuth.currentUser!.uid);
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
          profilePhoto: 'okhijjj',
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

//   void getuserData({
//     required String uid,
//   }) async {
//     List<String> thumbnails = [];
//     // var myVideos = await firestore
//     //     .collection('videos')
//     //     .where('uid', isEqualTo: uid)
//     //     .get();
//     // for (int i = 0; i < myVideos.docs.length; i++) {
//     //   thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
//     // }

//     // UserModel user = UserModel(
//     //   firstname: firstname,
//     //   lastname: lastname,
//     //   email: email,
//     //   phone: phone,
//     //   password: password,
//     //   uid: cred.user!.uid,
//     // );
//     DocumentSnapshot userDoc =
//         await firestore.collection('users').doc(uid).get();
//     final userData = userDoc.data() as Map;
//     UserModel user = UserModel(
//         firstname: userData['firstname'],
//         lastname: userData['lastname'],
//         email: userData['email'],
//         phone: userData['phone'],
//         password: userData['password'],
//         uid: userData['uid'],
//         profilePhoto: userData['profilePhoto']);
//     log(user.toString());

//     // String name = userData['name'];
//     // String profilePhoto = userData['profilePhoto'];
//     // int likes = 0;
//     int followers = 0;
//     int following = 0;
//     bool isFollowing = false;

//     // for (var item in myVideos.docs) {
//     //   likes += (item.data()['likes'] as List).length;
//     // }
//     var followerDoc = await firestore
//         .collection('users')
//         .doc(uid)
//         .collection('followers')
//         .get();
//     var followingDoc = await firestore
//         .collection('users')
//         .doc(uid)
//         .collection('following')
//         .get();
//     followers = followerDoc.docs.length;
//     following = followingDoc.docs.length;

// //check is fllowing
//     // firestore
//     //     .collection('users')
//     //     .doc(uid)
//     //     .collection('followers')
//     //     .doc(authController.user.uid)
//     //     .get()
//     //     .then((value) {
//     //   if (value.exists) {
//     //     isFollowing = true;
//     //   } else {
//     //     isFollowing = false;
//     //   }
//     // });

// //set value
//     // _user.value = {
//     //   'followers': followers.toString(),
//     //   'following': following.toString(),
//     //   'isFollowing': isFollowing,
//     //   'likes': likes.toString(),
//     //   'profilePhoto': profilePhoto,
//     //   'name': name,
//     //   'thumbnails': thumbnails,
//     // };
//   }
}
