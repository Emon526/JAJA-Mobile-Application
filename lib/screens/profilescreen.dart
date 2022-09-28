import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jaja/models/signupmodel.dart';
import 'package:jaja/models/user.dart';

import '../services/authservice.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  ProfileScreen({super.key, required this.uid});
  static const routeName = "/ProfileScreen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // AuthController().getuserData(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
          future: AuthController().getuserData(widget.uid),
          builder: (context, snapshot) {
            // final userData = snapshot.data as Map;
            log(snapshot.data.toString());

            var snapshots = snapshot.data as Map;
            log(snapshots.toString());

            // SignUpModel user = SignUpModel(
            //   firstname: userData['firstname'],
            //   lastname: userData['lastname'],
            //   email: userData['email'],
            //   phone: userData['phone'],
            //   password: userData['password'],
            //   uid: userData['uid'],
            //   profilePhoto: userData['profilePhoto'],
            // );
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Profile",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )),
                        InkWell(
                          onTap: () {
                            AuthController().signOut();
                          },
                          child: const Icon(
                            Icons.settings,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: size.width * 0.35,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () => {
                              // photocontroller.pickImage()
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Color(0xff90fc63),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      // '${user.firstname} ${user.lastname}',
                      'afbajdbf',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('0 Recordings'),
                      Text('0 Followers'),
                      Text('1 Followings'),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "My Recordings",
                      style: TextStyle(
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
            // if (!snapshot.hasData || snapshot.hasError) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else {}
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          AuthController().signOut();
          Navigator.pushNamed(context, '/HomeScreen');
        },
        child: const Icon(
          Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
