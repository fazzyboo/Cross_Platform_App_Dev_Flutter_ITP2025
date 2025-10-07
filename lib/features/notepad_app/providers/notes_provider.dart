import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database_service.dart';
import '../models/note.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<List<Note>> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final _notesStore = intMapStoreFactory.store('notes');

  NotesNotifier() : super([]) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final database = await _databaseService.database;
    final recordSnapshots = await _notesStore.find(database);
    state = recordSnapshots.map((snapshot) {
      return Note.fromMap(snapshot.value);
    }).toList();
  }

  Future<void> addNote(String title, String content) async {
    final newNote = Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    final database = await _databaseService.database;
    await _notesStore.add(database, newNote.toMap());
    state = [...state, newNote];
  }

  Future<void> deleteNote(String id) async {
    final database = await _databaseService.database;
    await _notesStore.delete(database, finder: Finder(filter: Filter.equals('id', id)));
    state = state.where((note) => note.id != id).toList();
  }

  Future<void> updateNote(String id, String newTitle, String newContent) async {
    final database = await _databaseService.database;
    final updatedNote = state.firstWhere((note) => note.id == id).copyWith(
          title: newTitle,
          content: newContent,
        );
    await _notesStore.update(database, updatedNote.toMap(),
        finder: Finder(filter: Filter.equals('id', id)));
    state = [
      for (final note in state)
        if (note.id == id) updatedNote else note,
    ];
  }
}
