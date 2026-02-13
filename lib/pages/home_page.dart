import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/pages/settings_page.dart';
import 'package:monthly_budget/pages/tags_page.dart';
import 'package:monthly_budget/widgets/summary_cards.dart';
import 'package:monthly_budget/widgets/item_list.dart';
import 'package:monthly_budget/widgets/add_item_sheet.dart';
import 'package:monthly_budget/widgets/month_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAddSheet({required bool isIncome}) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => AddItemSheet(isIncome: isIncome),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.label_outline),
                title: const Text('Show tags'),
                trailing: Switch(
                  value: appState.showTags,
                  onChanged: (_) => appState.toggleShowTags(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.label_outline),
                title: const Text('Tags'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TagsPage()),
                  );
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<RecurringFilter>(
                  segments: const [
                    ButtonSegment(value: RecurringFilter.all, label: Text('All')),
                    ButtonSegment(value: RecurringFilter.recurringOnly, label: Text('Recurring')),
                    ButtonSegment(value: RecurringFilter.oneTimeOnly, label: Text('One-time')),
                  ],
                  selected: {appState.recurringFilter},
                  onSelectionChanged: (selected) {
                    appState.setRecurringFilter(selected.first);
                  },
                ),
              ),
              if (appState.allTags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final tag in appState.allTags)
                          FilterChip(
                            label: Text(tag),
                            selected: appState.selectedTagFilters.contains(tag),
                            onSelected: (_) => appState.toggleTagFilter(tag),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              if (appState.hasActiveFilters)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => appState.clearFilters(),
                      child: const Text('Clear filters'),
                    ),
                  ),
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Monthly Budget'),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TotalsCard(
            totalExpenses: appState.totalExpenses,
            totalIncomes: appState.totalIncomes,
          ),
          BalanceCard(
            balance: appState.balance,
          ),
          const MonthSelector(),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Incomes'),
              Tab(text: 'Expenses'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ItemList(isIncome: true),
                ItemList(isIncome: false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final isIncome = _tabController.index == 0;
          _openAddSheet(isIncome: isIncome);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
