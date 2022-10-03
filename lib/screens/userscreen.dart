import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/authservice.dart';

class UserScreen extends StatelessWidget {
  final String uid;
  const UserScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    bool isFollowing = false;
    final firebaseauth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: const Color(0xff40039B),
        elevation: 0,
        title: const Text(
          'JAJA',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: firestore.collection('users').doc(uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List followers = snapshot.data!.get('followers');
                    isFollowing =
                        followers.contains(firebaseauth.currentUser!.uid);
                    final profilephoto = snapshot.data!.get('profilePhoto');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            color: Colors.grey.shade400,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: size.width / 4,
                                  height: size.width / 4,
                                  imageUrl: profilephoto,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    radius: 80,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: size.width * 0.1,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${snapshot.data!.get('firstname')} ${snapshot.data!.get('lastname')}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${followers.length} Followers',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            log(snapshot.data!.get('uid'));
                            isFollowing
                                ? AuthController().unfollowuser(
                                    followeruid: snapshot.data!.get('uid'))
                                : AuthController().followuser(
                                    followeruid: snapshot.data!.get('uid'));
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xff7BF946),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                isFollowing ? 'UnFollow' : 'Follow',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${snapshot.data!.get('firstname')}'s Recordings",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff7BF946),
        onPressed: () {
          // AuthController().signOut();
          Navigator.pushReplacementNamed(context, '/SearchUserScreen');
        },
        child: const Icon(
          Icons.home,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search',
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        prefixIcon: const Icon(
          Icons.search,
          size: 24,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
