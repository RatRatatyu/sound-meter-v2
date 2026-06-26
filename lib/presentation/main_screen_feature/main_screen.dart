import 'package:flutter/material.dart';



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
              child: Placeholder()
          ),
          AspectRatio(
            aspectRatio: 15/4,
            child: Placeholder(),
          ),
          Expanded(
              flex: 1,
              child: Placeholder()
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
                  child: Placeholder(),
                ),

                LayoutBuilder(
                  builder: (context, constraints) {

                    if (constraints.maxWidth < 300) {
                      return const SizedBox();
                    }

                    return const AspectRatio(
                      aspectRatio: 15 / 4,
                      child: Placeholder(),
                    );
                  },
                ),

                Expanded(
                  flex: 1,
                  child: Placeholder(),
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













