// import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
// import 'package:permission_handler/permission_handler.dart';

// final pathtosave = 'audio_example.aac';

// class SoundRecorder {
//   FlutterSoundRecorder? _audioRecorder;
//   bool _isRecoderInitialized = false;
//   bool get isRecording => _audioRecorder!.isRecording;
//   Future init() async {
//     _audioRecorder = FlutterSoundRecorder();
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone Permission denied');
//     }
//     await _audioRecorder!.openAudioSession();
//     _isRecoderInitialized = true;
//   }

//   void dispose() {
//     if (!_isRecoderInitialized) return;
//     _audioRecorder!.closeAudioSession();
//     _audioRecorder = null;
//     _isRecoderInitialized = false;
//   }

//   Future _record() async {
//     if (!_isRecoderInitialized) return;
//     await _audioRecorder!.startRecorder(
//       toFile: pathtosave,
//     );
//     // await _audioRecorder!.startRecorder(toFile: pathtosave);
//   }

//   Future _stop() async {
//     if (!_isRecoderInitialized) return;
//     await _audioRecorder!.stopRecorder();
//   }

//   Future toggleRevording() async {
//     if (_audioRecorder!.isStopped) {
//       await _record();
//     } else {
//       await _stop();
//     }
//   }
// }
