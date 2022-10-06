import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudRecordListView extends StatefulWidget {
  final List<Reference> references;
  const CloudRecordListView({
    Key? key,
    required this.references,
  }) : super(key: key);

  @override
  _CloudRecordListViewState createState() => _CloudRecordListViewState();
}

class _CloudRecordListViewState extends State<CloudRecordListView> {
  bool? isPlaying;
  late AudioPlayer audioPlayer;
  int? selectedIndex;

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
        return ListTile(
          title: Text(widget.references.elementAt(index).name),
          // leading: IconButton(
          //   onPressed: () => _onListTileDeleteButtonPressed(index),
          //   icon: const Icon(Icons.delete),
          // ),
          trailing: IconButton(
            icon: selectedIndex == index
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
            onPressed: () => _onListTilePlayButtonPressed(index),
          ),
        );
      },
    );
  }

  Future<void> _onListTileDeleteButtonPressed(int index) async {
    await widget.references.elementAt(index).delete();
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
}
