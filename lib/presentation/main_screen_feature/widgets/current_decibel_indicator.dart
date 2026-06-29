import 'package:flutter/material.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/providers/noise_meter_provider.dart';
import 'package:provider/provider.dart';


class CurrentDecimeterIndicator extends StatelessWidget {
  const CurrentDecimeterIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDecibel =
    context.select<NoiseMeterProvider, int>(
          (provider) => provider.currentDecibels,
    );
    return Center(
      child: Text(
        "$currentDecibel DB",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
