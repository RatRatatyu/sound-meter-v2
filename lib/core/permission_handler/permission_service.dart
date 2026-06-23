import 'dart:developer';

import 'package:noise_meter_v2/core/permission_handler/permission_types.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionService {
  Future<MicrophonePermissionStatus> checkMicrophonePermission() async{
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return MicrophonePermissionStatus.granted;
    }
    return MicrophonePermissionStatus.denied;
  }

  Future<MicrophonePermissionStatus> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      return MicrophonePermissionStatus.granted;
    }

    if (status.isPermanentlyDenied) {
      return MicrophonePermissionStatus.permanentlyDenied;
    }

    return MicrophonePermissionStatus.denied;
  }

  Future openSettings() async{
    openSettings();
  }
}