import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/usermodel.dart';
import '../../services/permissions.dart';

class FeatureButtonsView extends StatefulWidget {
  final Function onUploadComplete;
  const FeatureButtonsView({
    Key? key,
    required this.onUploadComplete,
  }) : super(key: key);
  @override
  _FeatureButtonsViewState createState() => _FeatureButtonsViewState();
}

class _FeatureButtonsViewState extends State<FeatureButtonsView> {
  late bool _isPlaying;
  late bool _isUploading;
  late bool _isRecorded;
  // late bool _isRecording;

  late AudioPlayer _audioPlayer;
  late String _filePath;
  var firestore = FirebaseFirestore.instance;
  var firebaseAuth = FirebaseAuth.instance;

  FlutterSoundRecorder? _audioRecorder;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    // _isRecording = false;
    _audioPlayer = AudioPlayer();
    _audioRecorder = FlutterSoundRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return _isRecorded
        ? _isUploading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Uplaoding'),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: _onRecordAgainButtonPressed,
                    child: const Icon(Icons.replay),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: _onPlayButtonPressed,
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: _onFileUploadButtonPressed,
                    child: const Icon(Icons.upload_file),
                  ),
                ],
              )
        : FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: _onRecordButtonPressed,
            child: _audioRecorder!.isRecording && PermissionSettings.isPermit
                ? const Icon(Icons.pause)
                : const Icon(Icons.mic),
          );
  }

  Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      final ref = firebaseStorage
          .ref('recordings')
          .child(firebaseAuth.currentUser!.uid)
          .child(_filePath.substring(
              _filePath.lastIndexOf('/'), _filePath.length));
      UploadTask uploadTask = ref.putFile(File(_filePath));

      await Future.value(uploadTask);
      // var imageurl = await ref.getDownloadURL();
      var imageurl = ref.name;

      final followingdata = await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      List recording = followingdata.get('recordings');
      recording.add(imageurl);
      // log(recording.toString());

      UserModel currentuser = UserModel(
        firstname: followingdata.get('firstname'),
        lastname: followingdata.get('lastname'),
        email: followingdata.get('email'),
        phone: followingdata.get('phone'),
        password: followingdata.get('password'),
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

      widget.onUploadComplete();
      setState(() {});
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _isRecorded = false;
      });
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_audioRecorder!.isRecording) {
      _audioRecorder!.stopRecorder();
      // _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      // _isRecording = true;

      await _startRecording(context: context);
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(
        DeviceFileSource(_filePath),
      );

      _audioPlayer.onPlayerComplete.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording({required BuildContext context}) async {
    // final status = await Permission.microphone.request();
    final status = PermissionSettings.isPermit;
    // log(status.toString());

    if (status) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

      await _audioRecorder!.openAudioSession();
      await _audioRecorder!.startRecorder(toFile: filepath);
      _filePath = filepath;
      setState(() {});
    } else {
      const snackbar = SnackBar(
        content: Text("Please enable recording permission"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      await PermissionSettings.promptPermissionSetting();
      // log('Microphone Permission denied');
      throw RecordingPermissionException('Microphone Permission denied');
    }
  }
}
