import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/widgets/add_item_sheet.dart';

/// Displays either expenses or incomes
/// depending on [isIncome].
class ItemList extends StatelessWidget {
  final bool isIncome;

  const ItemList({super.key, required this.isIncome});

  String _formatMoney(double value) =>
      value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final items = (isIncome ? appState.incomes : appState.expenses)
        .toList()
      ..sort((a, b) => (b.isRecurring ? 1 : 0) - (a.isRecurring ? 1 : 0));

    if (items.isEmpty) {
      return Center(
        child: Text(
          isIncome
              ? 'No incomes yet.'
              : 'No expenses yet.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];

        return Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.endToStart,
          // Swipe-to-delete interaction
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: Colors.red.withValues(alpha: 0.2),
            child: const Icon(Icons.delete),
          ),
          onDismissed: (_) {
            isIncome
                ? context
                    .read<AppState>()
                    .removeIncome(item.id)
                : context
                    .read<AppState>()
                    .removeExpense(item.id);
          },
          child: Card(
            child: ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  enableDrag: true,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (_) => AddItemSheet(
                    isIncome: isIncome,
                    existingItem: item,
                  ),
                );
              },
              title: Text(item.title),
              subtitle: appState.showTags && item.tags.isNotEmpty
                  ? Text(item.tags.join(', '))
                  : null,
              trailing: Text('${appState.currencySymbol} ${_formatMoney(item.amount)}'),
            ),
          ),
        );
      },
    );
  }
}
