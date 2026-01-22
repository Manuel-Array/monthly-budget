import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final month = appState.selectedMonth;
    final iconColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: appState.goToPreviousMonth,
            iconSize: 20,
            color: iconColor,
            visualDensity: VisualDensity.compact,
            tooltip: 'Previous month',
          ),
          InkWell(
            onTap: () => _showMonthPicker(context, appState),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                DateFormat.yMMMM().format(month),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: appState.goToNextMonth,
            iconSize: 20,
            color: iconColor,
            visualDensity: VisualDensity.compact,
            tooltip: 'Next month',
          ),
        ],
      ),
    );
  }

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
}

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
