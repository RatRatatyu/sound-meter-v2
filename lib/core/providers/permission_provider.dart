import 'package:flutter/material.dart';
import 'package:noise_meter_v2/core/permission_handler/permission_service.dart';
import '../../../core/permission_handler/permission_types.dart';


class PermissionProvider extends ChangeNotifier with WidgetsBindingObserver {
  var permissionService = PermissionService();

  MicrophonePermissionStatus _permissionStatus = MicrophonePermissionStatus.denied;
  MicrophonePermissionStatus get permissionStatus => _permissionStatus;

  PermissionProvider() {
    WidgetsBinding.instance.addObserver(this);
    initialCheck();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Automatically refresh when user returns from Phone Settings
    if (state == AppLifecycleState.resumed) {
      initialCheck();
    }
  }

  Future<void> requestPermission() async {
    final status = await permissionService.requestMicrophonePermission();
    _permissionStatus = status;
    notifyListeners();

  }

  Future<void> initialCheck() async{
    final status = await permissionService.checkMicrophonePermission();
    _permissionStatus = status;
    notifyListeners();

  }

  Future<void> openSettings() async{
    permissionService.openSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}