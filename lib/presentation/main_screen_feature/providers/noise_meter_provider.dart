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

    int _maxDecibels = 0;
    int get maxDecibels => _maxDecibels;

    int _avgDecibels = 0;
    int get avgDecibels => _avgDecibels;

    int _totalTicks = 0;
    double _sumDecibels = 0.0;

    bool _isListening = false;
    bool get isListening => _isListening;

    double _calibrationOffset = 90.0;
    double _smoothedDecibels = 0.0;


    Future<void> toggleListening(PermissionProvider permissionProvider) async{
      if(permissionProvider.permissionStatus != MicrophonePermissionStatus.granted){
        await permissionProvider.requestPermission();
        if(permissionProvider.permissionStatus != MicrophonePermissionStatus.granted){
          return;
        }
      }

      if(_isListening){
        await stopListen();
      }else{
        await startListen();
      }
    }


    Future<void> startListen() async {
      _isListening = true;
      await _audioRecorder.startAudioStream();
      await _audioSubscription?.cancel();

      _audioSubscription = _audioRecorder.amplitudeStream.listen((amplitude){
        double rawDb = amplitude.current;
        if (rawDb < -120) rawDb = -120;

        double currentCalibrated = rawDb + _calibrationOffset;
        if (currentCalibrated < 0) currentCalibrated = 0;

        double k = 0.3;
        _smoothedDecibels = (k * currentCalibrated) + ((1-k)* _smoothedDecibels);
        int newDecibels = _smoothedDecibels.round();

        if(newDecibels > _maxDecibels) _maxDecibels = newDecibels;

        _totalTicks++;
        _sumDecibels += newDecibels;
        _avgDecibels = (_sumDecibels / _totalTicks).round();

        if(newDecibels == _currentDecibels){
          return;
        }

        _currentDecibels = newDecibels;
        notifyListeners();
      });
    }

    Future<void> stopListen() async {
      _isListening = false;
      await _audioSubscription?.cancel();
      await _audioRecorder.onStopRecording();
      _currentDecibels = 0;
      _avgDecibels = 0;
      _maxDecibels = 0;
      _sumDecibels = 0;
      _totalTicks = 0;
      _smoothedDecibels = 0.0;
      notifyListeners();
    }

    @override
    void dispose() {
      _audioSubscription?.cancel();
      _audioRecorder.dispose();
      super.dispose();
    }



}