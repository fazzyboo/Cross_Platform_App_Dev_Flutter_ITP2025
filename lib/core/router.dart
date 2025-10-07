import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/notepad_app/pages/home_page.dart';
import '../features/notepad_app/pages/add_new_note_page.dart';
import '../features/notepad_app/pages/settings_page.dart';
import '../features/notepad_app/pages/note_detail_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/add-new-note',
        builder: (context, state) => const AddNewNotePage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/note-detail/:noteId',
        builder: (context, state) => NoteDetailPage(
          noteId: state.pathParameters['noteId']!,
        ),
      ),
    ],
  );
});
