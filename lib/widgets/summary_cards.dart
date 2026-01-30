import 'package:flutter/material.dart';
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
    final currencySymbol = context.watch<AppState>().currencySymbol;

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
                '$currencySymbol ${_formatMoney(balance)}',
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
    final currencySymbol = context.watch<AppState>().currencySymbol;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'Incomes',
              value: '$currencySymbol ${_formatMoney(totalIncomes)}',
              icon: Icons.trending_up,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: 'Expenses',
              value: '$currencySymbol ${_formatMoney(totalExpenses)}',
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
