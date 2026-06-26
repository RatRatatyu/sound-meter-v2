import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/permission_provider.dart';
import '../main_screen_feature/main_screen.dart';
import '../main_screen_feature/providers/noise_meter_provider.dart';



class NavigationShellScreen extends StatefulWidget {
  const NavigationShellScreen({super.key});

  @override
  State<NavigationShellScreen> createState() => _NavigationShellScreen();
}

class _NavigationShellScreen extends State<NavigationShellScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    MainScreen(),
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
    var isPhone = MediaQuery.sizeOf(context).shortestSide < 600;

    return Scaffold(
      appBar: AppBar(),
      drawer: isPhone ? null : Drawer(
        child: ListView(
          padding: .zero,
          children: <Widget>[
            const DrawerHeader( // change to NavigationRail?
              decoration: BoxDecoration(color: Colors.purple),
              child: Center(child: Icon(Icons.pets),),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("home"),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.history_edu),
              title: const Text("History"),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              } ,
            )
          ],
        ),
      ) ,
      body: SafeArea(
        child: IndexedStack(
        index: _selectedIndex,
        children: _screens,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        onPressed: () => startListen.toggleListening(permissions),
        tooltip: startListen.isListening ? "Stop noise meter" : "Start noise meter",
        child: startListen.isListening ? Icon(Icons.pause) : Icon(Icons.play_arrow) ,
      ),
      bottomNavigationBar: isPhone ? BottomNavigationBar(
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
      ) : null,
      floatingActionButtonLocation: isPhone ? FloatingActionButtonLocation.centerDocked : FloatingActionButtonLocation.endFloat,
    );
  }
}