import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  void _showAddTagDialog(BuildContext context, AppState appState) {
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

              final isDuplicate = appState.allTags.any(
                (t) => t.toLowerCase() == tagName.toLowerCase(),
              );
              if (isDuplicate) return;

              appState.addTag(tagName);
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
    final appState = context.watch<AppState>();
    final tags = appState.allTags.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: tags.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No tags yet.\nTap + to create one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          : ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) => _TagTile(tag: tags[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTagDialog(context, appState),
        child: const Icon(Icons.add),
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
