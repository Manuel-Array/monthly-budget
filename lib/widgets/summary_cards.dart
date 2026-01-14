import 'package:flutter/material.dart';

/// Displays the money left card prominently.
class MoneyLeftCard extends StatelessWidget {
  final double moneyLeft;

  const MoneyLeftCard({
    super.key,
    required this.moneyLeft,
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
                'Money Left',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '€ ${_formatMoney(moneyLeft)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays fixed expenses and incomes side by side.
class FixedTotalsCards extends StatelessWidget {
  final double fixedExpensesTotal;
  final double fixedIncomesTotal;

  const FixedTotalsCards({
    super.key,
    required this.fixedExpensesTotal,
    required this.fixedIncomesTotal,
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
              title: 'Fixed Expenses',
              value: '€ ${_formatMoney(fixedExpensesTotal)}',
              icon: Icons.trending_down,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: 'Fixed Incomes',
              value: '€ ${_formatMoney(fixedIncomesTotal)}',
              icon: Icons.trending_up,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal reusable card used only by SummaryCards.
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
