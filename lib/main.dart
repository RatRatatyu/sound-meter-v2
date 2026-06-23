import 'package:flutter/material.dart';
import 'package:noise_meter_v2/core/providers/permission_provider.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PermissionProvider()..initialCheck())
      ],
      child: const MyApp(),
    ),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}


