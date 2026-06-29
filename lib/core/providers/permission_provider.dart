import 'package:flutter/material.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/providers/noise_meter_provider.dart';

import '../services/permission_handler/permission_service.dart';
import '../services/permission_handler/permission_types.dart';



class PermissionProvider extends ChangeNotifier with WidgetsBindingObserver {
  final PermissionService permissionService = PermissionService();


  MicrophonePermissionStatus _permissionStatus = MicrophonePermissionStatus.denied;
  MicrophonePermissionStatus get permissionStatus => _permissionStatus;

  bool get isDialogShow => _permissionStatus == MicrophonePermissionStatus.permanentlyDenied;

  PermissionProvider(){
    WidgetsBinding.instance.addObserver(this);
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