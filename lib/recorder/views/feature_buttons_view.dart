import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/usermodel.dart';

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
  double maxduration = 25.0;

  final AudioPlayer _audioPlayer = AudioPlayer();
  late String _filePath;
  var firestore = FirebaseFirestore.instance;
  var firebaseAuth = FirebaseAuth.instance;

  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  String _recorderTxt = '00:00:00';

  Future<void> _initializeExample() async {
    await _audioRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
    await initializeDateFormatting();
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _audioRecorder.openRecorder();
  }

  Future<void> init() async {
    await openTheRecorder();
    await _initializeExample();
  }

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startRecorder() async {
    try {
      // Request Microphone permission if needed

      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }

      Directory directory = await getApplicationDocumentsDirectory();
      String filepath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

      await _audioRecorder.startRecorder(
        toFile: filepath,
      );
      _filePath = filepath;

      _audioRecorder.onProgress!.listen((e) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            e.duration.inMilliseconds,
            isUtc: true);
        var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

        setState(() {
          _recorderTxt = txt.substring(0, 8);
        });
        // log('duration : ${e.duration.inSeconds}');
        if (e.duration.inSeconds == maxduration) {
          setState(() {
            stopRecorder();
            _isRecorded = true;
          });
          const snackbar = SnackBar(
            content: Text("Maximum Duration 25 Seconds"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      });

      setState(() {});
    } on Exception catch (err) {
      _audioRecorder.logger.e('startRecorder error: $err');
      setState(() {
        stopRecorder();
      });
    }
  }

  void stopRecorder() async {
    try {
      await _audioRecorder.stopRecorder();
      _audioRecorder.logger.d('stopRecorder');
    } on Exception catch (err) {
      _audioRecorder.logger.d('stopRecorder error: $err');
    }
    setState(() {});
  }

  startStopRecorder() {
    if (_audioRecorder.isRecording || _audioRecorder.isPaused) {
      stopRecorder();
      _isRecorded = true;
    } else {
      _isRecorded = false;
      startRecorder();
    }
  }

  void Function()? onStartRecorderPressed() {
    return startStopRecorder;
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
        : _audioRecorder.isRecording
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _recorderTxt,
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    // onPressed: _onRecordButtonPressed,
                    onPressed: onStartRecorderPressed(),
                    child: _audioRecorder.isRecording
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.mic),
                  ),
                ],
              )
            : FloatingActionButton(
                backgroundColor: Colors.green,
                // onPressed: _onRecordButtonPressed,
                onPressed: onStartRecorderPressed(),
                child: _audioRecorder.isRecording
                    ? const Icon(Icons.stop)
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
      // print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
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
}
