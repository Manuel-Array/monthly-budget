import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/pages/settings_page.dart';
import 'package:monthly_budget/widgets/summary_cards.dart';
import 'package:monthly_budget/widgets/item_list.dart';
import 'package:monthly_budget/widgets/add_item_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAddSheet({required bool isIncome}) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => AddItemSheet(isIncome: isIncome),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          MoneyLeftCard(
            moneyLeft: appState.moneyLeft,
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Incomes'),
              Tab(text: 'Expenses'),
            ],
          ),
          TotalsCards(
            expensesTotal: appState.totalExpenses,
            incomesTotal: appState.totalIncomes,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ItemList(isIncome: true),
                ItemList(isIncome: false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final isIncome = _tabController.index == 0;
          _openAddSheet(isIncome: isIncome);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
