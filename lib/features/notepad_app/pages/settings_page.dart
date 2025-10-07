import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Added missing import
import '../providers/theme_provider.dart';
import '../providers/font_size_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
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
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: fontSize + 4),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: fontSize + 2, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('Light', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize)),
                Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),
                Text('Dark', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Font Size',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: fontSize + 2, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: fontSize,
              min: 10.0,
              max: 50.0,
              divisions: 40, // (50 - 10) = 40 divisions
              label: fontSize.round().toString(),
              onChanged: (newSize) {
                ref.read(fontSizeProvider.notifier).setFontSize(newSize);
              },
            ),
            Text(
              'Current Font Size: ${fontSize.round()}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }
}
