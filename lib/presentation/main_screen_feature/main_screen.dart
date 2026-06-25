import 'package:flutter/material.dart';
import 'package:noise_meter_v2/core/providers/permission_provider.dart';
import 'package:noise_meter_v2/presentation/main_screen_feature/providers/noise_meter_provider.dart';
import 'package:provider/provider.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
      TestScreen1(),
      TestScreen2()
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    var permissions = context.watch<PermissionProvider>();
    var startListen = context.watch<NoiseMeterProvider>();

    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          onPressed: () => startListen.toggleListening(permissions),
          tooltip: startListen.isListening ? "Start noise meter" : "Stop noise meter",
          child: startListen.isListening ? Icon(Icons.play_arrow) : Icon(Icons.pause),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.history_edu), label: "History"
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepPurple,
          onTap: _onItemTapped,
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}



class TestScreen1 extends StatelessWidget {
  const TestScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(color: Colors.red,);
  }
}

class TestScreen2 extends StatelessWidget {
  const TestScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(color: Colors.blue,);
  }
}













