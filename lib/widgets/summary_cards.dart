import 'package:flutter/material.dart';

/// Displays the main financial summary:
/// fixed expenses, fixed incomes and money left.
class SummaryCards extends StatelessWidget {
  final double fixedExpensesTotal;
  final double fixedIncomesTotal;
  final double moneyLeft;

  const SummaryCards({
    super.key,
    required this.fixedExpensesTotal,
    required this.fixedIncomesTotal,
    required this.moneyLeft,
  });

  String _formatMoney(double value) =>
      value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        children: [
          Row(
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
          const SizedBox(height: 12),
          _SummaryCard(
            title: 'Money Left',
            value: '€ ${_formatMoney(moneyLeft)}',
            icon: Icons.account_balance_wallet,
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
