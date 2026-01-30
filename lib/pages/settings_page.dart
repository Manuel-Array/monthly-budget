import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showCurrencyPicker(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select currency'),
        children: AppState.currencies.entries.map((entry) {
          return SimpleDialogOption(
            onPressed: () {
              appState.setCurrency(entry.key);
              Navigator.pop(context);
            },
            child: Text('${entry.key} (${entry.value})'),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Currency'),
            trailing: Text(appState.currencyCode),
            onTap: () => _showCurrencyPicker(context, appState),
          ),
        ],
      ),
    );
  }
}
