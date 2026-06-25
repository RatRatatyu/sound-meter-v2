import 'dart:typed_data';

import 'package:record/record.dart';


class AudioRecordService {
  final _record = AudioRecorder();

  Stream<Amplitude> get amplitudeStream => _record.onAmplitudeChanged(
    const Duration(milliseconds: 200)
  );

  Future<Stream<Uint8List>> startAudioStream() async {
    const config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 44100,
      numChannels: 1,
      autoGain: false,
      noiseSuppress: false,
    );

    return await _record.startStream(config);
  }

  Future<void> onStopRecording() async{
    await _record.stop();
  }


  Future<void> dispose() async{
    await _record.dispose();
  }
}
