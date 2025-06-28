import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class DarkLightToggle extends StatefulWidget {
  const DarkLightToggle({super.key});

  @override
  State<DarkLightToggle> createState() => _DarkLightToggle();
}

class _DarkLightToggle extends State<DarkLightToggle> {
  final List<bool> _selectedTheme = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    var themeNotifier = context.watch<ThemeNotifier>();
    bool isDark = themeNotifier.themeMode == ThemeMode.dark;

    _selectedTheme[0] = !isDark;
    _selectedTheme[1] = isDark;

    return ToggleButtons(
      borderRadius: BorderRadius.circular(12),
      isSelected: _selectedTheme,
      constraints: BoxConstraints(minWidth: 48), // Adjust values as needed
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _selectedTheme.length; i++) {
            _selectedTheme[i] = i == index;
          }
          themeNotifier.toggleTheme(index == 1);
        });
      },
      children: const [Icon(Icons.sunny), Icon(Icons.nightlight_round)],
    );
  }
}
