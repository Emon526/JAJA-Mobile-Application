import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
        // return ListTile(
        //   title: Text(widget.references.elementAt(index).name),
        //   leading: widget.uid == firebaseauth.currentUser!.uid
        //       ? IconButton(
        //           onPressed: () => _onListTileDeleteButtonPressed(index),
        //           icon: const Icon(Icons.delete),
        //         )
        //       : SizedBox(
        //           width: 0,
        //           height: 0,
        //         ),
        //   trailing: IconButton(
        //     icon: selectedIndex == index
        //         ? const Icon(Icons.pause)
        //         : const Icon(Icons.play_arrow),
        //     onPressed: () => _onListTilePlayButtonPressed(index),
        //   ),
        // );
      },
    );
  }

  Future<void> _onListTileDeleteButtonPressed(int index) async {
    await widget.references.elementAt(index).delete();
    log(widget.references.elementAt(index).toString());
    widget.ondeleteComplete();
  }

  Future<void> _onListTilePlayButtonPressed(int index) async {
    setState(() {
      selectedIndex = index;
    });

    audioPlayer.play(await widget.references.elementAt(index).getDownloadURL(),
        isLocal: false);

    audioPlayer.onPlayerCompletion.listen((duration) {
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
              : SizedBox()
        ],
      ),
    );
  }
}
