import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/widgets/summary_cards.dart';
import 'package:monthly_budget/widgets/fixed_list.dart';
import 'package:monthly_budget/widgets/add_fixed_item_sheet.dart';

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

    // Seed demo data only once, after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().seedDemoDataIfEmpty();
    });
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
      builder: (_) => AddFixedItemSheet(isIncome: isIncome),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Budget'),
      ),
      body: Column(
        children: [
          MoneyLeftCard(
            moneyLeft: appState.moneyLeft,
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Fixed Expenses'),
              Tab(text: 'Fixed Incomes'),
            ],
          ),
          FixedTotalsCards(
            fixedExpensesTotal: appState.totalFixedExpenses,
            fixedIncomesTotal: appState.totalFixedIncomes,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                FixedList(isIncome: false),
                FixedList(isIncome: true),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final isIncome = _tabController.index == 1;
          _openAddSheet(isIncome: isIncome);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}
