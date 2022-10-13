import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'userscreen.dart';

class SearchUser extends StatefulWidget {
  static const routeName = "/SearchUserScreen";
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  // bool isShowUsers = false;

  final firebaseauth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final searchuserController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          children: [
            _buildSearchBar(
              size: size.width,
              ontapprofileimage: () {
                Navigator.pushNamed(context, '/ProfileScreen');
              },
              controller: searchuserController,
              uid: firebaseauth.currentUser!.uid,
            ),
            searchuserController.text.isNotEmpty
                ? _buildSearchResult(
                    text: searchuserController.text.toUpperCase(),
                    size: size.width,
                  )
                : _buildTranding(
                    firebaseAuth: firebaseauth,
                    firestore: firestore,
                    size: size.width,
                  ),
          ],
        ),
      ),
    );
  }

  _buildTranding(
      {required FirebaseFirestore firestore,
      required double size,
      required FirebaseAuth firebaseAuth}) {
    return Expanded(
      child: StreamBuilder(
          stream: firestore
              .collection('users')
              .orderBy(
                'followers',
                descending: true,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Flexible(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          // log(data.data().toString());

                          //skip current user
                          if (data.id == firebaseAuth.currentUser!.uid) {
                            return Container(height: 0);
                          }
                          final List followers = data.get('followers');
                          return _buildUserCard(
                              imageurl: data.get('profilePhoto'),
                              title:
                                  '${data.get('firstname')} ${data.get('lastname')}',
                              follewers: '${followers.length} Followers',
                              size: size,
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserScreen(uid: data.get('uid'))));
                                // log(data.get('uid'));
                              });
                        }),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  _buildSearchBar({
    required double size,
    required String uid,
    required Function ontapprofileimage,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Flexible(
          child: Form(
            child: TextFormField(
              controller: controller,
              autofocus: false,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
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
        ),
        SizedBox(
          width: size * 0.02,
        ),

        // profile icon
        InkWell(
          onTap: () {
            ontapprofileimage();
          },
          child: StreamBuilder(
              stream: firestore.collection('users').doc(uid).snapshots(),
              builder: (context, snapshot) {
                // // log(snapshot.data.data().toString());

                if (snapshot.hasData) {
                  final profilephoto = snapshot.data!.get('profilePhoto');
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: size / 6,
                      height: size / 6,
                      imageUrl: profilephoto,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: size * 0.14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
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

  _buildSearchResult({
    required String text,
    required double size,
  }) {
    return Expanded(
      child: StreamBuilder(
        stream: firestore
            .collection('users')
            .where(
              'firstname',
              isGreaterThanOrEqualTo: text,
            )
            .snapshots(),
        builder: (context, snapshot) {
          // log(snapshot.data!.docs.length.toString());
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Search Result",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      // log(data.data().toString());

                      //skip current user
                      // if (data.id == firebaseAuth.currentUser!.uid) {
                      //   return Container(height: 0);
                      // }
                      final List followers = data.get('followers');
                      return _buildUserCard(
                          imageurl: data.get('profilePhoto'),
                          title:
                              '${data.get('firstname')} ${data.get('lastname')}',
                          follewers: '${followers.length} Followers',
                          size: size,
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserScreen(uid: data.get('uid'))));
                            // log(data.get('uid'));
                          });
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
