import 'package:flutter/material.dart';

import '../state/app_controller.dart';
import 'dish_library_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(controller: widget.controller),
      DishLibraryScreen(controller: widget.controller),
      HistoryScreen(controller: widget.controller),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.casino_outlined),
            selectedIcon: Icon(Icons.casino),
            label: 'Quay món',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Kho món',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
        ],
      ),
    );
  }
}
