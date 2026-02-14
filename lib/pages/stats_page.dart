import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/widgets/month_selector.dart';
import 'package:monthly_budget/widgets/stats_charts.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final hasData =
        appState.totalMonthExpenses > 0 || appState.totalMonthIncomes > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Column(
        children: [
          const MonthSelector(),
          Expanded(
            child: hasData
                ? SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (appState.totalMonthExpenses > 0) ...[
                          _SectionHeader(
                            title: 'Expenses',
                            total: appState.totalMonthExpenses,
                            currencySymbol: appState.currencySymbol,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'By tag',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          TagDistributionChart(
                            data: appState.expensesByTag,
                            currencySymbol: appState.currencySymbol,
                            total: appState.totalMonthExpenses,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Recurring vs one-time',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          RecurringSplitChart(
                            recurringTotal: appState.recurringExpensesTotal,
                            oneTimeTotal: appState.oneTimeExpensesTotal,
                            currencySymbol: appState.currencySymbol,
                          ),
                        ],
                        if (appState.totalMonthExpenses > 0 &&
                            appState.totalMonthIncomes > 0)
                          const Divider(height: 32),
                        if (appState.totalMonthIncomes > 0) ...[
                          _SectionHeader(
                            title: 'Incomes',
                            total: appState.totalMonthIncomes,
                            currencySymbol: appState.currencySymbol,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'By tag',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          TagDistributionChart(
                            data: appState.incomesByTag,
                            currencySymbol: appState.currencySymbol,
                            total: appState.totalMonthIncomes,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Recurring vs one-time',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          RecurringSplitChart(
                            recurringTotal: appState.recurringIncomesTotal,
                            oneTimeTotal: appState.oneTimeIncomesTotal,
                            currencySymbol: appState.currencySymbol,
                          ),
                        ],
                      ],
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No data for this month.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final double total;
  final String currencySymbol;

  const _SectionHeader({
    required this.title,
    required this.total,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          Text(
            '$currencySymbol ${total.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
