import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/permission_handler/permission_types.dart';
import '../../../core/providers/permission_provider.dart';



class MicrophonePermissionBanner extends StatelessWidget {
  const MicrophonePermissionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    var permissionRequest = context.watch<PermissionProvider>();

    switch (permissionRequest.permissionStatus) {

      case MicrophonePermissionStatus.granted:
        return Expanded(
            flex: 1,
            child:Container(color: Colors.red)
        );

      case MicrophonePermissionStatus.denied:
        return ElevatedButton(
          onPressed: () async {
            await permissionRequest.requestPermission();
          },
          child: const Text("Request permission"),
        );

      case MicrophonePermissionStatus.permanentlyDenied:
        return ElevatedButton(
          onPressed: () async {
            await _showDialog(context);
          },
          child: const Text("Request permission"),
        );
    }
  }
}

Future<void> _showDialog(BuildContext context) async{
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Microphone permission"),
          content: const Text("We need access to your microphone to measure noise"),
          actions: [
            TextButton(
                onPressed: ()=>  Navigator.pop(context),
                child: const Text("Disable")
            ),
            TextButton(
                onPressed: ()  {
                  Navigator.pop(context);
                  context.read<PermissionProvider>().openSettings();
                },
                child: const Text("Enable")
            ),
          ],
        );
      }
  );
}


