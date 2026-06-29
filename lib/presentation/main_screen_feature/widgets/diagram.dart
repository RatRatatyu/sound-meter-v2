import 'dart:async';
import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/providers/noise_meter_provider.dart';
import 'package:provider/provider.dart';

/// Можно оптимизовать еще
class Diagram extends StatefulWidget {
  const Diagram({super.key});

  @override
  State<Diagram> createState() => _DiagramState();
}

class _DiagramState extends State<Diagram> {

  NoiseMeterProvider? _provider;
  Timer? _collapseTimer;
  bool _wasListening = false;
  ListQueue<double> _localSpots = ListQueue();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newProvider = context.read<NoiseMeterProvider>();

    if (_provider != newProvider) {
      _provider?.removeListener(_providerListener);

      _provider = newProvider;
      _provider?.addListener(_providerListener);
    }
  }


  void _providerListener(){
    final currentProvider = _provider;
    if (currentProvider == null) return;

    if(currentProvider.isListening){
      setState(() {
        _localSpots = ListQueue.of(currentProvider.spots);
        _wasListening = true;
      });
    }else if(_wasListening && !currentProvider.isListening){
      _wasListening = false;
      _startCollapseAnimation();
    }
  }

  void _startCollapseAnimation(){
    _collapseTimer?.cancel();

    _collapseTimer = Timer.periodic(
      const Duration(milliseconds: 50),
          (timer) {
        if (_localSpots.isEmpty) {
          _stopAnimation();
          return;
        }

        setState(() {
          if (_localSpots.isNotEmpty) {
            _localSpots.removeFirst();
            _localSpots.addLast(0);
          }
        });

        final allZeros = _localSpots.every((db) => db == 0);

        if (allZeros) {
          _stopAnimation();
        }
      },
    );
  }

  void _stopAnimation() {
    _collapseTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _localSpots.clear();
    });
    _provider?.cleanSpots();
  }

  @override
  Widget build(BuildContext context) {

    List<double> data= _localSpots.toList();

    List<FlSpot> spots = data.isEmpty
        ? [const FlSpot(0, 0)]
        : List.generate(data.length, (index) {
      return FlSpot(index.toDouble(), data[index].toDouble());
    });

    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        minY: 0,
        maxY: 120,
        minX: 0,
        maxX: 20.0,
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 40,
            )
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          )

        ),
        gridData: const FlGridData(show: false),
        //borderData: FlBorderData(show: false),
        //clipData: const FlClipData.all(),
        lineBarsData: [
          LineChartBarData(
            show: true,
            color: Colors.deepPurple,
            spots: spots,
            barWidth: 3,
            isCurved: false,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.withAlpha(70),
                  Colors.deepPurpleAccent.withAlpha(70),
                  Colors.indigoAccent.withAlpha(70)
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight
              )
            )
          )
        ]

      ),
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    _provider?.removeListener(_providerListener);
    super.dispose();
  }
}
