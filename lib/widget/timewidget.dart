// import 'dart:async';

// import 'package:flutter/material.dart';

// class TimeController extends ValueNotifier<bool> {
//   TimeController({bool isPlaying = false}) : super(isPlaying);
//   void startTimer() => value = true;
//   void stopTimer() => value = false;
// }

// class TImerWidget extends StatefulWidget {
//   final TimeController controller;
//   final Function uploadbuttonTap;
//   const TImerWidget({
//     super.key,
//     required this.uploadbuttonTap,
//     required this.controller,
//   });

//   @override
//   State<TImerWidget> createState() => _TImerWidgetState();
// }

// class _TImerWidgetState extends State<TImerWidget> {
//   Duration duration = const Duration();
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(() {
//       if (widget.controller.value) {
//         startTimer();
//       } else {
//         stopTimer();
//       }
//     });
//   }

//   void reset() => setState(() => duration = const Duration());
//   void addTime() {
//     const addsecond = 1;

//     setState(() {
//       final seconds = duration.inSeconds + addsecond;
//       if (seconds < 0) {
//         timer?.cancel();
//       } else {
//         duration = Duration(seconds: seconds);
//       }
//     });
//   }

//   void startTimer({bool resets = true}) {
//     if (!mounted) return;
//     if (resets) {
//       reset();
//     }
//     timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
//   }

//   void stopTimer({bool resets = true}) {
//     // if (!mounted) return;
//     // if (resets) {
//     //   reset();
//     // }
//     setState(() => timer?.cancel());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildTimer();
//   }

//   Widget buildTimer() {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));

//     return Card(
//       color: Colors.green,
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           children: [
//             // IconButton(
//             //   icon: const Icon(Icons.play_arrow),
//             //   onPressed: () {},
//             // ),
//             Text(
//               '$minutes:$seconds',
//               style: const TextStyle(
//                 fontSize: 24,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             // IconButton(
//             //   icon: const Icon(Icons.delete),
//             //   onPressed: () {},
//             // ),
//             InkWell(
//               onTap: () {
//                 widget.uploadbuttonTap();
//               },
//               child: const Padding(
//                 padding: EdgeInsets.all(4.0),
//                 child: Icon(Icons.upload),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
