import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/models/fixed_item.dart';

/// Displays either fixed expenses or fixed incomes
/// depending on [isIncome].
class FixedList extends StatelessWidget {
  final bool isIncome;

  const FixedList({super.key, required this.isIncome});

  String _formatMoney(double value) =>
      value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final List<FixedItem> items =
        isIncome ? appState.fixedIncomes : appState.fixedExpenses;

    if (items.isEmpty) {
      return Center(
        child: Text(
          isIncome
              ? 'No fixed incomes yet.'
              : 'No fixed expenses yet.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];

        return Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.endToStart,
          // Swipe-to-delete interaction
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: Colors.red.withOpacity(0.2),
            child: const Icon(Icons.delete),
          ),
          onDismissed: (_) {
            isIncome
                ? context
                    .read<AppState>()
                    .removeFixedIncome(item.id)
                : context
                    .read<AppState>()
                    .removeFixedExpense(item.id);
          },
          child: Card(
            child: ListTile(
              title: Text(item.title),
              trailing:
                  Text('€ ${_formatMoney(item.amount)}'),
              subtitle:
                  Text(isIncome ? 'Income' : 'Expense'),
            ),
          ),
        );
      },
    );
  }
}
