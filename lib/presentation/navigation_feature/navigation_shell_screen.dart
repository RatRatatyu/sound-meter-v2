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

  static const List<Widget> _screens = <Widget>[MainScreen(), TestScreen2()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var startListen = context.select<NoiseMeterProvider, bool>(
      (provider) => provider.isListening,
    );
    var isDialogShow = context.select<PermissionProvider, bool>(
      (provider) => provider.isDialogShow,
    );
    var toggleListen = context.read<NoiseMeterProvider>();
    var permissions = context.read<PermissionProvider>();

    var isPhone = MediaQuery.sizeOf(context).shortestSide < 600;

    return Scaffold(
      appBar: AppBar(),
      drawer: isPhone
          ? null
          : Drawer(
              child: ListView(
                padding: .zero,
                children: <Widget>[
                  const DrawerHeader(
                    // change to NavigationRail?
                    decoration: BoxDecoration(color: Colors.purple),
                    child: Center(child: Icon(Icons.pets)),
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
                    },
                  ),
                ],
              ),
            ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _screens),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        onPressed: () {
          if (isDialogShow) {
            showPermissionDialog(
              context: context,
              permission: permissions.openSettings,
            );
          } else {
            toggleListen.toggleListening();
          }
        },
        tooltip: startListen ? "Stop noise meter" : "Start noise meter",
        child: startListen ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
      bottomNavigationBar: isPhone
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_edu),
                  label: "History",
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.deepPurple,
              onTap: _onItemTapped,
            )
          : null,
      floatingActionButtonLocation: isPhone
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
    );
  }
}

Future<void> showPermissionDialog({
  required BuildContext context,
  required VoidCallback permission,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Request microphone permission"),
        content: const Text("The app need permission to meter noise level"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Disable"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              permission();
            },
            child: const Text("Enable"),
          ),
        ],
      );
    },
  );
}
