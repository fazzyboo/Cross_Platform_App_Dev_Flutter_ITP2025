import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notes_provider.dart';
import '../providers/font_size_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
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
      body: notes.isEmpty
          ? Center(
              child: Text(
                'No notes yet. Add one!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: fontSize * 0.8),
                    ),
                    onTap: () {
                      context.push('/note-detail/${note.id}');
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref.read(notesProvider.notifier).deleteNote(note.id);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-new-note'); // Changed go to push
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
