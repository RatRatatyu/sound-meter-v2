import 'package:flutter/material.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/widgets/additional_decimeter_indicators.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/widgets/current_decimeter_indicator.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/widgets/diagram.dart';



class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation == Orientation.portrait;

    if(orientation){
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(color: Colors.purple,),
          ),
          Expanded(
              flex: 1,
              child: CurrentDecimeterIndicator()
          ),
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 2.0,
              child: Diagram(),
            ),
          ),
          Expanded(
              flex: 1,
              child: AdditionalDecimeterIndicators()
          ),
        ],
      );
    }else{
      return Row(
        children: [

          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [

                Expanded(
                  flex: 1,
                  child: CurrentDecimeterIndicator(),
                ),

                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 300) {
                        return const SizedBox();
                      }

                      return const AspectRatio(
                        aspectRatio: 2.0,
                        child: Diagram(),
                      );
                    },
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: AdditionalDecimeterIndicators(),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}




// leaving for test
class TestScreen2 extends StatelessWidget {
  const TestScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(color: Colors.blue,);
  }
}













