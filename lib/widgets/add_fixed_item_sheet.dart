import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/models/fixed_item.dart';

/// Bottom sheet used to add a new fixed expense or income.
class AddFixedItemSheet extends StatefulWidget {
  final bool isIncome;

  const AddFixedItemSheet({
    super.key,
    required this.isIncome,
  });

  @override
  State<AddFixedItemSheet> createState() =>
      _AddFixedItemSheetState();
}

class _AddFixedItemSheetState
    extends State<AddFixedItemSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final rawAmount =
        _amountController.text.trim().replaceAll(',', '.');
    final amount = double.tryParse(rawAmount);

    // Simple validation before touching AppState
    if (title.isEmpty) {
      setState(() => _errorMessage = 'Title is required.');
      return;
    }

    if (amount == null || amount <= 0) {
      setState(() => _errorMessage =
          'Amount must be greater than zero.');
      return;
    }

    final item = FixedItem(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      title: title,
      amount: amount,
    );

    final appState = context.read<AppState>();
    widget.isIncome
        ? appState.addFixedIncome(item)
        : appState.addFixedExpense(item);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isIncome
                ? 'Add Fixed Income'
                : 'Add Fixed Expense',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount (EUR)',
              border: OutlineInputBorder(),
            ),
            keyboardType:
                const TextInputType.numberWithOptions(
                    decimal: true),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .error,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
