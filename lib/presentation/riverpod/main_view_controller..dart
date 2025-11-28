import 'package:flutter_riverpod/flutter_riverpod.dart';

// mainPage riverPod

final mainViewProvider = StateNotifierProvider<MainViewNotifier, int>((ref) {
  return MainViewNotifier();
});

class MainViewNotifier extends StateNotifier<int> {
  MainViewNotifier() : super(0); // <-- DEFAULT INDEX MUST BE 0

  void changeIndex(int index) {
    state = index;
  }
}
// theme provider

final appThemeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // false => Light theme by default

  void toggleTheme() {
    state = !state; // switch between light & dark
  }
}