// import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';

class PermissionSettings {
  // request storage permission
  static bool isPermit = false;
  static Future<bool> promptPermissionSetting() async {
    final request = await Permission.microphone.request();

    if (request.isGranted) {
      // log(request.isGranted.toString());
      isPermit = true;
      return true;
    } else {
      // log(request.isGranted.toString());
      isPermit = false;
      return false;
    }
  }
}
