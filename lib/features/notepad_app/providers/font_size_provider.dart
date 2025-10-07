import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier();
});

class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier() : super(20.0) { // Changed initial font size to be within 10-50 range
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final fontSize = prefs.getDouble('fontSize');
    if (fontSize != null) {
      state = fontSize;
    }
  }

  Future<void> setFontSize(double newSize) async {
    state = newSize;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', newSize);
  }
}
