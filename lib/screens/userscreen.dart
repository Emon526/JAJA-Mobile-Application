import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../recorder/views/cloud_record_list_view.dart';
import '../services/authservice.dart';

class UserScreen extends StatefulWidget {
  final String uid;
  const UserScreen({super.key, required this.uid});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Reference> references = [];
  bool isFollowing = false;
  final firebaseauth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final searchuserController = TextEditingController();
  @override
  void initState() {
    _onUploadComplete(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset:
          searchuserController.text.isEmpty ? false : true,
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
            _buildSearchBar(
              controller: searchuserController,
            ),
            const SizedBox(
              height: 20,
            ),
            searchuserController.text.isNotEmpty
                ? _buildSearchResult(
                    text: searchuserController.text.toUpperCase(),
                    size: size.width,
                  )
                : SingleChildScrollView(
                    child: StreamBuilder(
                        stream: firestore
                            .collection('users')
                            .doc(widget.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List followers =
                                snapshot.data!.get('followers');
                            isFollowing = followers
                                .contains(firebaseauth.currentUser!.uid);
                            final profilephoto =
                                snapshot.data!.get('profilePhoto');
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: Colors.grey.shade400,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                            followeruid:
                                                snapshot.data!.get('uid'))
                                        : AuthController().followuser(
                                            followeruid:
                                                snapshot.data!.get('uid'));
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
                                Container(
                                  height: size.height * 0.4,
                                  child: references.isEmpty
                                      ? const Center(
                                          child: Text('No File uploaded yet'),
                                        )
                                      : CloudRecordListView(
                                          ondeleteComplete: () {},
                                          uid: widget.uid,
                                          references: references,
                                        ),
                                )
                              ],
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
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

  _buildSearchBar({
    required TextEditingController controller,
  }) {
    return Form(
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
    return Flexible(
      flex: 1,
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
                            log(data.get('uid'));
                          });
                    }),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onUploadComplete({required String uid}) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
        await firebaseStorage.ref('recordings').child(uid).list();

    setState(() {
      references = listResult.items;
    });
  }
}
