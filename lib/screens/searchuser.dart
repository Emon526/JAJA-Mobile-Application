import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SearchUser extends StatelessWidget {
  static const routeName = "/SearchUserScreen";
  const SearchUser({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final firebaseauth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff40039B),
        elevation: 0,
        title: const Text(
          'JAJA',
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(
              size: size.width,
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Trending",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: firestore.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index];
                            // log(data.data().toString());
                            return _buildUserCard(
                                imageurl: data.get('profilePhoto'),
                                title:
                                    '${data.get('firstname')} ${data.get('lastname')}',
                                follewers: '0',
                                size: size.width,
                                onTap: () {
                                  log(data.get('uid'));
                                });
                          });
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
            ),
            // Expanded(
            //     child: FirebaseAnimatedList(
            //   query: databaseref,
            //   defaultChild: const Center(
            //     child: CircularProgressIndicator(),
            //   ),
            //   itemBuilder: (context, snapshot, animation, index) {
            //     // log(snapshot.value.toString());
            //     if (snapshot.value
            //         .toString()
            //         .contains(FirebaseAuth.instance.currentUser!.uid)) {
            //       return SizedBox();
            //     }
            //     return _buildUserCard(
            //       onTap: () {
            //         Navigator.pushNamed(context, '/UserScreen');
            //         log('message1');
            //       },
            //       title:
            //           '${snapshot.child('firstname').value} ${snapshot.child('lastname').value} '
            //               .toString(),
            //       follewers: '0 Followers',
            //       imageurl: '${snapshot.child('profilePhoto').value}',
            //       size: size.width,
            //     );
            //   },
            // )),
          ],
        ),
      ),
    );
  }

  _buildSearchBar({required double size, required BuildContext context}) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            autofocus: false,
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
          ),
        ),
        SizedBox(
          width: size * 0.02,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/ProfileScreen');
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              size: size * 0.1,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }

  _buildUserCard({
    required String imageurl,
    required String title,
    required String follewers,
    required double size,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            follewers,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(2),
              color: Colors.grey.shade400,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: size / 7,
                    height: size / 7,
                    imageUrl: imageurl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: size * 0.1,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
