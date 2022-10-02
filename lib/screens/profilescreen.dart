import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/authservice.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });
  static const routeName = "/ProfileScreen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebaseauth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
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
      body: StreamBuilder(
          stream: firestore
              .collection('users')
              .doc(firebaseauth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            // // log(snapshot.data.data().toString());

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
                            Icons.logout_outlined,
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
                      '${snapshot.data!.get('firstname')} ${snapshot.data!.get('lastname')}',
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
                      Text(
                        ' 1 Followers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      // snapshot.data!.get('email'),
                      'Your Recordings',
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
      // body: FutureBuilder<DocumentSnapshot>(
      //   future: FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(widget.uid)
      //       .get(),
      //   builder:
      //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('Something went wrong');
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Text("Loading");
      //     }

      //     // return ListView(
      //     //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //     //     Map<String, dynamic> data =
      //     //         document.data()! as Map<String, dynamic>;
      //     //     log(data.toString());
      //     //     return ListTile(
      //     //       // data['company']
      //     //       title: Text('data.toString()'),
      //     //       subtitle: Text('yhug'),
      //     //     );
      //     //   }).toList(),
      //     // );
      //     // return ListView(
      //     //   children: snapshot.data!.map((DocumentSnapshot document) {
      //     // final data = SignUpModel.fromSnap(snapshot.data!);
      //     //     log(data.toString());
      //     //     return ListTile(
      //     //       // data['company']
      //     //       title: Text('data.toString()'),
      //     //       subtitle: Text('yhug'),
      //     //     );
      //     //   }).toList(),
      //     // );

      //     log(snapshot.data!.id.toString());
      //     log(snapshot.data!.toString());
      //     // log(snapshot.data!.reference.toString());
      //     return Text(snapshot.data!.toString());
      //   },
      // ),

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
