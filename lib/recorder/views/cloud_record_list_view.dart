import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../models/usermodel.dart';

class CloudRecordListView extends StatefulWidget {
  final Function ondeleteComplete;
  final List<Reference> references;
  final String uid;
  const CloudRecordListView({
    Key? key,
    required this.references,
    required this.uid,
    required this.ondeleteComplete,
  }) : super(key: key);

  @override
  _CloudRecordListViewState createState() => _CloudRecordListViewState();
}

class _CloudRecordListViewState extends State<CloudRecordListView> {
  bool? isPlaying;
  late AudioPlayer audioPlayer;
  int? selectedIndex;
  final firebaseauth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    audioPlayer = AudioPlayer();
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.references.length,
      itemBuilder: (BuildContext context, int index) {
        return listcard(
          index: index,
        );
      },
    );
  }

  Future<void> _onListTileDeleteButtonPressed(int index) async {
    await widget.references.elementAt(index).delete();
    _updaterecordingData(index: index);
    widget.ondeleteComplete();
  }

  Future<void> _onListTilePlayButtonPressed(int index) async {
    setState(() {
      selectedIndex = index;
    });
    audioPlayer.play(
        UrlSource(await widget.references.elementAt(index).getDownloadURL()));
    audioPlayer.onPlayerComplete.listen((duration) {
      setState(() {
        selectedIndex = -1;
      });
    });
  }

  Widget listcard({required index}) {
    return Card(
      child: Row(
        children: [
          IconButton(
            icon: selectedIndex == index
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
            onPressed: () => _onListTilePlayButtonPressed(index),
          ),
          Expanded(child: Text(widget.references.elementAt(index).name)),
          widget.uid == firebaseauth.currentUser!.uid
              ? IconButton(
                  onPressed: () => _onListTileDeleteButtonPressed(index),
                  icon: const Icon(Icons.delete),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Future<void> _updaterecordingData({required int index}) async {
    var firebaseAuth = FirebaseAuth.instance;

    try {
      final followingdata = await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      List recording = followingdata.get('recordings');
      recording.removeAt(index);

      UserModel currentuser = UserModel(
        firstname: followingdata.get('firstname'),
        lastname: followingdata.get('lastname'),
        email: followingdata.get('email'),
        phone: followingdata.get('phone'),
        uid: followingdata.get('uid'),
        profilePhoto: followingdata.get('profilePhoto'),
        followers: followingdata.get('followers'),
        following: followingdata.get('following'),
        recordings: recording,
      );

      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(currentuser.toJson());

      setState(() {});
    } catch (error) {
      // print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }
}
