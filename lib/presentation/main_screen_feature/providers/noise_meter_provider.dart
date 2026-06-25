import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:noise_meter_v2/core/services/noise_meter_handler/audio_record_service.dart';
import 'package:noise_meter_v2/core/providers/permission_provider.dart';

import '../../../core/services/permission_handler/permission_types.dart';

class NoiseMeterProvider extends ChangeNotifier{
    final _audioRecorder = AudioRecordService();
    StreamSubscription? _audioSubscription;

    int _currentDecibels = 0;
    int get currentDecibels  => _currentDecibels;

    bool _isListening = false;
    bool get isListening => _isListening;


    Future<void> toggleListening(PermissionProvider permissionProvider) async{
      if(permissionProvider.permissionStatus != MicrophonePermissionStatus.granted){
        await permissionProvider.requestPermission();
        if(permissionProvider.permissionStatus != MicrophonePermissionStatus.granted){
          return;
        }
      }

      if(_isListening){
        stopListen();
      }else{
        startListen();
      }
    }


    Future<void> startListen() async {
      _isListening = true;
      await _audioRecorder.startAudioStream();
      await _audioSubscription?.cancel();

      _audioSubscription = _audioRecorder.amplitudeStream.listen((amplitude){
        double noiseLevel = amplitude.current +100;

        if (noiseLevel < 0) noiseLevel = 0;

        _currentDecibels = noiseLevel.round();
        log("$currentDecibels");
        notifyListeners();
      });
    }

    Future<void> stopListen() async {
      _isListening = false;
      await _audioSubscription?.cancel();
      await _audioRecorder.onStopRecording();
      _currentDecibels = 0;
      notifyListeners();
    }

    @override
    void dispose() {
      _audioSubscription?.cancel();
      _audioRecorder.dispose();
      super.dispose();
    }



}