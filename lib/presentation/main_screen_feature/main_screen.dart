import 'package:flutter/material.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/widgets/permission_baner.dart';



class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(color: Colors.deepPurple,),
          ),
          MicrophonePermissionBanner(),
          AspectRatio(
            aspectRatio: 16/9,
            child: Container(color: Colors.green),
          ),
          Expanded(
            flex: 2,
            child: Container(color: Colors.red,),
          ),
        ],
      ),
      backgroundColor: Colors.white30,
    );
  }
}








