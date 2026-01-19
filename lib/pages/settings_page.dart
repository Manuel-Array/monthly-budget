import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tags = appState.allTags.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Tags',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          if (tags.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                'No tags yet. Tags will appear here once you add them to your items.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...tags.map((tag) => _TagTile(tag: tag)),
        ],
      ),
    );
  }
}

class _TagTile extends StatelessWidget {
  final String tag;

  const _TagTile({required this.tag});

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: tag);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Tag name',
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
              final newName = controller.text.trim();
              if (newName.isEmpty || newName == tag) {
                Navigator.pop(dialogContext);
                return;
              }

              context.read<AppState>().renameTag(tag, newName);
              Navigator.pop(dialogContext);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete tag'),
        content: Text(
          'Remove "$tag" from all items? The items will remain, only the tag will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AppState>().deleteTag(tag);
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tag),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showRenameDialog(context),
            tooltip: 'Rename',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}
