import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/providers/noise_meter_provider.dart';
import 'package:provider/provider.dart';

class Diagram extends StatefulWidget {
  const Diagram({super.key});

  @override
  State<Diagram> createState() => _DiagramState();
}

class _DiagramState extends State<Diagram> {
  @override
  Widget build(BuildContext context) {
    final data = context.select<NoiseMeterProvider, List<int>>(
      (provider) => provider.slidingWindow
    );

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
        minX: 20.0,
        maxX: 0,
        titlesData: const FlTitlesData(
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
            spots: spots,
            color: Colors.deepPurple,
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
}
