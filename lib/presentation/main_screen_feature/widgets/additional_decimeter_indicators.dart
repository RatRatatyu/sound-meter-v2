import 'package:flutter/material.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/providers/noise_meter_provider.dart';
import 'package:provider/provider.dart';

class AdditionalDecimeterIndicators extends StatelessWidget {
  const AdditionalDecimeterIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    final maxDecibels = context.select<NoiseMeterProvider, int>(
        (provider) => provider.maxDecibels
    );

    final avgDecibels = context.select<NoiseMeterProvider, int>(
            (provider) => provider.avgDecibels
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Indicator(indicatorName: "MAX", indicatorValue: maxDecibels),
        Indicator(indicatorName: "AVG", indicatorValue: avgDecibels),
      ],
    );
  }
}


class Indicator extends StatelessWidget {
 const Indicator({
   super.key,
   required this.indicatorName,
   required this.indicatorValue
 });

 final int indicatorValue;
 final String indicatorName;

 @override
 Widget build(BuildContext context) {
   return Column(
     children: [
       Text(
         indicatorName,
         style: Theme.of(context).textTheme.bodyLarge,
       ),
       Text(
         "$indicatorValue dB",
         style: Theme.of(context).textTheme.headlineSmall,
       ),
     ],
   );
 }
}
