import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/usermodel.dart';
import '../recorder/views/cloud_record_list_view.dart';
import '../recorder/views/feature_buttons_view.dart';
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
  List<Reference> references = [];
  final firebaseauth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final firebasestorage = FirebaseStorage.instance;
  bool showtimer = false;
  File? _image;

  Future selectfile() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // log('No image Selected');
      }
    });

    //   // Upload file
    final ref = firebasestorage
        .ref('profileimages')
        .child(firebaseauth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(_image!.absolute);

    await Future.value(uploadTask);
    var imageurl = await ref.getDownloadURL();

    final followersdata = await firestore
        .collection('users')
        .doc(firebaseauth.currentUser!.uid)
        .get();

    UserModel user = UserModel(
      firstname: followersdata.get('firstname'),
      lastname: followersdata.get('lastname'),
      email: followersdata.get('email'),
      phone: followersdata.get('phone'),
      password: followersdata.get('password'),
      uid: followersdata.get('uid'),
      profilePhoto: imageurl,
      followers: followersdata.get('followers'),
      following: followersdata.get('following'),
      recordings: followersdata.get('recordings'),
    );
    await firestore
        .collection('users')
        .doc(firebaseauth.currentUser!.uid)
        .set(user.toJson());
    // log(imageurl.toString());
  }

  // final timeController = TimeController();
  // final recorder = SoundRecorder();

  @override
  void initState() {
    // recorder.init();
    _onUploadComplete();
    super.initState();
  }

  @override
  void dispose() {
    // recorder.dispose();
    super.dispose();
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
      body: StreamBuilder(
          stream: firestore
              .collection('users')
              .doc(firebaseauth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final profilephoto = snapshot.data!.get('profilePhoto');
              final List followers = snapshot.data!.get('followers');
              final List following = snapshot.data!.get('following');
              final List recordings = snapshot.data!.get('recordings');

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
                            AuthController().signOut(context);
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _image != null
                              ? Image.file(
                                  _image!.absolute,
                                  width: size.width / 3,
                                  height: size.width / 3,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: size.width / 3,
                                  height: size.width / 3,
                                  imageUrl: profilephoto,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    radius: 80,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: size.width * 0.30,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () => {
                              // log('Pick Image and upload choosed one'),
                              selectfile(),
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
                    children: [
                      Text(
                        '${recordings.length} Recordings',
                      ),
                      Text(
                        '${followers.length} Followers',
                      ),
                      Text(
                        '${following.length} Followings',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Your Recordings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    // flex: 4,
                    child: references.isEmpty
                        ? const Center(
                            child: Text('No File uploaded yet'),
                          )
                        : CloudRecordListView(
                            ondeleteComplete: _onUploadComplete,
                            uid: firebaseauth.currentUser!.uid,
                            references: references,
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
      floatingActionButton: FeatureButtonsView(
        onUploadComplete: _onUploadComplete,
      ),
    );
  }

  Future<void> _onUploadComplete() async {
    // FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult = await firebasestorage
        .ref('recordings')
        .child(firebaseauth.currentUser!.uid)
        .list();

    setState(() {
      references = listResult.items;
    });
  }
}
