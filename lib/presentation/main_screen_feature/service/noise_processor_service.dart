import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';


class NoiseMetrics{
  final int current;
  final int max;
  final int average;
  final ListQueue<double> window;

  const NoiseMetrics(this.current, this.max, this.average, this.window,);


}

class NoiseProcessorService {

  int _maxDb = 0;
  int _avgDb = 0;
  final ListQueue<double> _window = ListQueue();
  double _calibrationOffset = 90.0;

  double _sumDecibels = 0;
  int _totalTicks = 0;
  double _smoothedDecibels = 0.0;

  static const int _windowSize = 20;


  NoiseMetrics process(double rawDb){
    double currentCalibrated = rawDb + _calibrationOffset;
    if (currentCalibrated < 0) currentCalibrated = 0;

    const double k = 0.3;
    _smoothedDecibels = (k * currentCalibrated) + ((1-k)* _smoothedDecibels);
    double newDecibels = _smoothedDecibels;

    if(newDecibels > _maxDb) _maxDb = newDecibels.round();

    _totalTicks++;
    _sumDecibels += newDecibels;
    _avgDb = (_sumDecibels / _totalTicks).round();

    if(_window.length >= _windowSize){
      _window.removeFirst();
    }
    _window.addLast(newDecibels);

    int currentDecibels = newDecibels.round();

    return NoiseMetrics(
        currentDecibels,
        _maxDb,
        _avgDb,
        _window
    );
  }

  void reset(){
    _window.clear();
    _avgDb = 0;
    _maxDb =0;
    _totalTicks = 0;
    _sumDecibels =0;
    _smoothedDecibels = 0.0;

  }

}