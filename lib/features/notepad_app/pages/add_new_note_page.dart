import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notes_provider.dart';
import '../providers/font_size_provider.dart';

class AddNewNotePage extends ConsumerStatefulWidget {
  const AddNewNotePage({super.key});

  @override
  ConsumerState<AddNewNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends ConsumerState<AddNewNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      ref.read(notesProvider.notifier).addNote(title, content);
      context.pop(); // Go back to the previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Add New Note',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: fontSize + 4),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 28.0), // Made icon larger
            onPressed: () {
              context.push('/settings'); // Changed go to push
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
                border: const OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
                  border: const OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Make button full width
                foregroundColor: Theme.of(context).colorScheme.onPrimary, // Text color
              ),
              child: Text(
                'Save Note',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
