import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter_v2/core/providers/permission_provider.dart';
import 'package:noise_meter_v2/core/services/noise_meter_handler/audio_record_service.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/service/noise_processor_service.dart';

import '../../../core/services/permission_handler/permission_types.dart';

class NoiseMeterProvider extends ChangeNotifier with WidgetsBindingObserver {
  final _audioRecorder = AudioRecordService();
  StreamSubscription? _audioSubscription;

  final PermissionProvider permissionProvider;
  final NoiseProcessorService noiseProcessorService;

  int _currentDecibels = 0;
  int get currentDecibels => _currentDecibels;

  int _maxDecibels = 0;
  int get maxDecibels => _maxDecibels;

  int _avgDecibels = 0;
  int get avgDecibels => _avgDecibels;

  ListQueue<double> _spots = ListQueue();
  ListQueue<double> get spots => _spots;

  bool _isListening = false;
  bool get isListening => _isListening;



  NoiseMeterProvider(
      {required this.permissionProvider, required this.noiseProcessorService}) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      await _stopListen();
    }
  }

  Future<void> toggleListening() async {
    if (permissionProvider.permissionStatus !=
        MicrophonePermissionStatus.granted) {
      await permissionProvider.requestPermission();

      if (permissionProvider.permissionStatus !=
          MicrophonePermissionStatus.granted) {
        return;
      }
    }

    if (isListening) {
      await _stopListen();
    } else {
      await _startListen();
    }
  }


  Future<void> _startListen() async {
    _isListening = true;
    await _audioRecorder.startAudioStream();
    await _audioSubscription?.cancel();

    _audioSubscription = _audioRecorder.amplitudeStream.listen((amplitude) {
      double rawDb = amplitude.current;
      if (rawDb < -120) rawDb = -120;

      NoiseMetrics result = noiseProcessorService.process(rawDb);
      _maxDecibels = result.max;
      _avgDecibels = result.average;
      _spots = result.window;
      _currentDecibels = result.current;
      notifyListeners();
    });
  }



  Future<void> _stopListen() async {
    _isListening = false;
    await _audioSubscription?.cancel();
    await _audioRecorder.onStopRecording();
    _currentDecibels = 0;
    _avgDecibels = 0;
    _maxDecibels = 0;
    noiseProcessorService.reset();
    notifyListeners();
  }

  void cleanSpots(){
    _spots.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioSubscription?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }
}