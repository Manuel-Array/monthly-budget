import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';

/// Displays the balance card prominently.
class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  String _formatMoney(double value) =>
      value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance_wallet, size: 32),
              const SizedBox(height: 8),
              Text(
                'Balance',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '€ ${_formatMoney(balance)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays expenses and incomes totals side by side.
class TotalsCard extends StatelessWidget {
  final double totalExpenses;
  final double totalIncomes;

  const TotalsCard({
    super.key,
    required this.totalExpenses,
    required this.totalIncomes,
  });

  String _formatMoney(double value) =>
      value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'Incomes',
              value: '€ ${_formatMoney(totalIncomes)}',
              icon: Icons.trending_up,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: 'Expenses',
              value: '€ ${_formatMoney(totalExpenses)}',
              icon: Icons.trending_down,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal reusable card used only by TotalsCard.
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(value,
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays month selector and totals in a single row.
class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key});

  String _formatMoney(double value) => value.toStringAsFixed(2);

  void _showMonthPicker(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _MonthPickerSheet(
        selectedMonth: appState.selectedMonth,
        onSelect: (month) {
          appState.setSelectedMonth(month);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _CompactCard(
              onTap: () => _showMonthPicker(context, appState),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMM().format(appState.selectedMonth),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, size: 20, color: Colors.green[700]),
                  const SizedBox(height: 4),
                  Text(
                    '€${_formatMoney(appState.totalIncomes)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_down, size: 20, color: Colors.red[700]),
                  const SizedBox(height: 4),
                  Text(
                    '€${_formatMoney(appState.totalExpenses)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact card used in SummaryRow.
class _CompactCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _CompactCard({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: child,
        ),
      ),
    );
  }
}

/// Month picker sheet with year navigation and month grid.
class _MonthPickerSheet extends StatefulWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onSelect;

  const _MonthPickerSheet({
    required this.selectedMonth,
    required this.onSelect,
  });

  @override
  State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<_MonthPickerSheet> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = widget.selectedMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() => _year--),
                ),
                Text(
                  '$_year',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => _year++),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(12, (index) {
                final month = index + 1;
                final isSelected = month == widget.selectedMonth.month &&
                    _year == widget.selectedMonth.year;

                return InkWell(
                  onTap: () => widget.onSelect(DateTime(_year, month)),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormat.MMM().format(DateTime(_year, month)),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
