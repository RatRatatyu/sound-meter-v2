import 'dart:developer';

import 'package:noise_meter_v2/core/permission_handler/permission_types.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> getMicrophoneStatus() async {
    return await Permission.microphone.status;
  }

  Future<PermissionStatus> requestMicrophonePermission() async {
    return await Permission.microphone.request();
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}