import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/models/item.dart';

/// Bottom sheet used to add a new expense or income.
class AddItemSheet extends StatefulWidget {
  final bool isIncome;
  final Item? existingItem;

  const AddItemSheet({
    super.key,
    required this.isIncome,
    this.existingItem,
  });

  @override
  State<AddItemSheet> createState() =>
      _AddItemSheetState();
}

class _AddItemSheetState
    extends State<AddItemSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _errorMessage;
  bool _isRecurring = false;
  Set<String> _selectedTags = {};
  final Set<String> _sessionTags = {};

  @override
  void initState() {
    super.initState();

    final item = widget.existingItem;
    if (item != null) {
      _titleController.text = item.title;
      _amountController.text = item.amount.toStringAsFixed(2);
      _isRecurring = item.isRecurring;
      _selectedTags = item.tags.toSet();
    }
  }

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

    final item = Item(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      title: title,
      amount: amount,
      isRecurring: _isRecurring,
      tags: _selectedTags.toList(),
    );

    final appState = context.read<AppState>();

    if (widget.existingItem == null) {
      // Add
      widget.isIncome
          ? appState.addIncome(item)
          : appState.addExpense(item);
    } else {
      // Update: keep the same id
      final updated = Item(
        id: widget.existingItem!.id,
        title: title,
        amount: amount,
        isRecurring: _isRecurring,
        tags: _selectedTags.toList(),
      );

      widget.isIncome
          ? appState.updateIncome(updated)
          : appState.updateExpense(updated);
    }

    Navigator.of(context).pop();
  }

  void _showAddTagDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tag name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final tagName = controller.text.trim();
              if (tagName.isEmpty) return;

              final allTags = {
                ...context.read<AppState>().allTags,
                ..._sessionTags
              };
              final isDuplicate = allTags.any(
                (t) => t.toLowerCase() == tagName.toLowerCase(),
              );

              if (!isDuplicate) {
                setState(() {
                  _sessionTags.add(tagName);
                  _selectedTags.add(tagName);
                });
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
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
            widget.existingItem == null
                ? (widget.isIncome
                    ? 'Add Income'
                    : 'Add Expense')
                : (widget.isIncome
                    ? 'Edit Income'
                    : 'Edit Expense'),
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
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _isRecurring,
            onChanged: (value) =>
                setState(() => _isRecurring = value ?? false),
            title: const Text('Recurring monthly'),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tags',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final tag in {
                  ...context.watch<AppState>().allTags,
                  ..._sessionTags
                })
                  FilterChip(
                    label: Text(tag),
                    selected: _selectedTags.contains(tag),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Add tag'),
                  onPressed: _showAddTagDialog,
                ),
              ],
            ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.existingItem == null
                      ? 'Save'
                      : 'Save changes',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
