import 'package:flutter/material.dart';

import 'package:monthly_budget/pages/home_page.dart';
import 'package:monthly_budget/pages/stats_page.dart';

enum _MainTab { home, statistics }

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  _MainTab _selectedTab = _MainTab.home;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [HomePage(), StatsPage()];
    assert(_pages.length == _MainTab.values.length);
  }

  int get _selectedIndex => _selectedTab.index;

  void _onDestinationSelected(int index) {
    final nextTab = _MainTab.values[index];
    if (nextTab == _selectedTab) return;
    setState(() => _selectedTab = nextTab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}
