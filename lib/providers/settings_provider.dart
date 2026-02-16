import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSizeScale = 1.0;

  bool get isDarkMode => _isDarkMode;
  double get fontSizeScale => _fontSizeScale;

  static const List<double> fontScales = [0.85, 1.0, 1.25, 1.5];
  static const List<String> fontScaleLabels = ['صغير', 'عادي', 'كبير', 'أكبر'];

  int get fontSizeIndex {
    final idx = fontScales.indexOf(_fontSizeScale);
    return idx >= 0 ? idx : 1;
  }

  String get fontSizeLabel => fontScaleLabels[fontSizeIndex];
  bool get canIncrease => fontSizeIndex < fontScales.length - 1;
  bool get canDecrease => fontSizeIndex > 0;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _fontSizeScale = prefs.getDouble('fontSizeScale') ?? 1.0;
    if (!fontScales.contains(_fontSizeScale)) {
      _fontSizeScale = 1.0;
    }
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> increaseFontSize() async {
    if (canIncrease) {
      _fontSizeScale = fontScales[fontSizeIndex + 1];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fontSizeScale', _fontSizeScale);
      notifyListeners();
    }
  }

  Future<void> decreaseFontSize() async {
    if (canDecrease) {
      _fontSizeScale = fontScales[fontSizeIndex - 1];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fontSizeScale', _fontSizeScale);
      notifyListeners();
    }
  }

  Future<void> setFontSizeScale(double scale) async {
    if (fontScales.contains(scale)) {
      _fontSizeScale = scale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fontSizeScale', _fontSizeScale);
      notifyListeners();
    }
  }
}
