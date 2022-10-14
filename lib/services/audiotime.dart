

// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart' show DateFormat;
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';

// class Demo extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<Demo> {
//   final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

//   String _recorderTxt = '00:00:00';

//   Future<void> _initializeExample() async {
//     await _audioRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
//     await initializeDateFormatting();
//   }

//   Future<void> openTheRecorder() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone permission not granted');
//     }
//     await _audioRecorder.openRecorder();
//   }

//   Future<void> init() async {
//     await openTheRecorder();
//     await _initializeExample();
//   }

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void startRecorder() async {
//     try {
//       // Request Microphone permission if needed

//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         throw RecordingPermissionException('Microphone permission not granted');
//       }

//       Directory directory = await getApplicationDocumentsDirectory();
//       String filepath =
//           '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

//       await _audioRecorder.startRecorder(
//         toFile: filepath,
//       );
//       // _filePath = filepath;

//       _audioRecorder.onProgress!.listen((e) {
//         var date = DateTime.fromMillisecondsSinceEpoch(
//             e.duration.inMilliseconds,
//             isUtc: true);
//         var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

//         setState(() {
//           _recorderTxt = txt.substring(0, 8);
//         });
//       });

//       setState(() {});
//     } on Exception catch (err) {
//       _audioRecorder.logger.e('startRecorder error: $err');
//       setState(() {
//         stopRecorder();
//       });
//     }
//   }

//   void stopRecorder() async {
//     try {
//       await _audioRecorder.stopRecorder();
//       _audioRecorder.logger.d('stopRecorder');
//     } on Exception catch (err) {
//       _audioRecorder.logger.d('stopRecorder error: $err');
//     }
//     setState(() {});
//   }

//   void pauseResumeRecorder() async {
//     try {
//       if (_audioRecorder.isPaused) {
//         await _audioRecorder.resumeRecorder();
//       } else {
//         await _audioRecorder.pauseRecorder();
//         assert(_audioRecorder.isPaused);
//       }
//     } on Exception catch (err) {
//       _audioRecorder.logger.e('error: $err');
//     }
//     setState(() {});
//   }

//   void Function()? onPauseResumeRecorderPressed() {
//     if (_audioRecorder.isPaused || _audioRecorder.isRecording) {
//       return pauseResumeRecorder;
//     }
//     return null;
//   }

//   startStopRecorder() {
//     if (_audioRecorder.isRecording || _audioRecorder.isPaused) {
//       stopRecorder();
//     } else {
//       startRecorder();
//     }
//   }

//   void Function()? onStartRecorderPressed() {
//     return startStopRecorder;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Sound Demo'),
//       ),
//       body: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               _recorderTxt,
//               style: const TextStyle(
//                 fontSize: 35.0,
//                 color: Colors.black,
//               ),
//             ),
//             TextButton(
//               onPressed: onStartRecorderPressed(),
//               child: Icon(
//                 _audioRecorder.isStopped ? Icons.mic : Icons.stop,
//               ),
//             ),
//           ]),
//     );
//   }
// }
