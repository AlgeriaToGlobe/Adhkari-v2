import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/adhkar_category.dart';
import '../models/dhikr.dart';
import '../data/sample_data.dart';

class AdhkarProvider extends ChangeNotifier {
  List<AdhkarCategory> _categories = [];
  List<FreeDhikrItem> _freeDhikrItems = [];
  bool _vibrationEnabled = true;

  // Tasbeeh state
  int _tasbeehCount = 0;
  int _tasbeehTarget = 33;
  String _tasbeehLabel = 'سبحان الله';

  List<AdhkarCategory> get categories => _categories;
  List<FreeDhikrItem> get freeDhikrItems => _freeDhikrItems;
  bool get vibrationEnabled => _vibrationEnabled;
  int get tasbeehCount => _tasbeehCount;
  int get tasbeehTarget => _tasbeehTarget;
  String get tasbeehLabel => _tasbeehLabel;

  int _streakCount = 0;
  List<bool> _weekCompletion = List.filled(7, false);

  int get streakCount => _streakCount;
  List<bool> get weekCompletion => _weekCompletion;

  int get totalAdhkar =>
      _categories.fold(0, (sum, cat) => sum + cat.totalCount);
  int get completedAdhkar =>
      _categories.fold(0, (sum, cat) => sum + cat.completedCount);
  double get overallProgress =>
      totalAdhkar > 0 ? completedAdhkar / totalAdhkar : 0.0;

  AdhkarProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _categories = SampleData.getCategories();
    final prefs = await SharedPreferences.getInstance();

    final lastReset = prefs.getString('lastResetDate');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (lastReset != today) {
      // Update streak — check if yesterday had progress
      final yesterday = prefs.getString('lastResetDate');
      if (yesterday != null) {
        final hadProgress = prefs.getBool('day_had_progress') ?? false;
        if (hadProgress) {
          _streakCount = (prefs.getInt('streak_count') ?? 0) + 1;
        } else {
          _streakCount = 0;
        }
      }
      await prefs.setInt('streak_count', _streakCount);
      await prefs.setBool('day_had_progress', false);

      // Update week history — shift and add today
      final todayWeekday = DateTime.now().weekday - 1; // 0=Monday
      _weekCompletion = List.filled(7, false);
      final historyJson = prefs.getString('week_history');
      if (historyJson != null) {
        final List<dynamic> old = jsonDecode(historyJson);
        for (int i = 0; i < 7 && i < old.length; i++) {
          _weekCompletion[i] = old[i] as bool;
        }
      }
      await prefs.setString('week_history', jsonEncode(_weekCompletion));

      await prefs.setString('lastResetDate', today);
      for (final category in _categories) {
        for (final dhikr in category.adhkar) {
          await prefs.setInt('count_${dhikr.id}', 0);
        }
      }
    } else {
      for (final category in _categories) {
        for (final dhikr in category.adhkar) {
          dhikr.currentCount = prefs.getInt('count_${dhikr.id}') ?? 0;
        }
      }
    }

    _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;

    // Load tasbeeh
    _tasbeehCount = prefs.getInt('tasbeehCount') ?? 0;
    _tasbeehTarget = prefs.getInt('tasbeehTarget') ?? 33;
    _tasbeehLabel = prefs.getString('tasbeehLabel') ?? 'سبحان الله';

    // Load free dhikr items
    final itemsJson = prefs.getString('freeDhikrItems');
    if (itemsJson != null) {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      _freeDhikrItems =
          decoded.map((e) => FreeDhikrItem.fromJson(e)).toList();
    }

    // Load streak data
    _streakCount = prefs.getInt('streak_count') ?? 0;
    final weekJson = prefs.getString('week_history');
    if (weekJson != null) {
      final List<dynamic> decoded = jsonDecode(weekJson);
      _weekCompletion = decoded.map((e) => e as bool).toList();
      if (_weekCompletion.length != 7) _weekCompletion = List.filled(7, false);
    }

    notifyListeners();
  }

  // ── Adhkar category methods ──

  Future<void> incrementDhikr(String categoryId, String dhikrId) async {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    final dhikr = category.adhkar.firstWhere((d) => d.id == dhikrId);
    if (!dhikr.isCompleted) {
      dhikr.increment();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('count_${dhikr.id}', dhikr.currentCount);
      notifyListeners();

      // Mark today as having progress for streak tracking
      final streakPrefs = await SharedPreferences.getInstance();
      await streakPrefs.setBool('day_had_progress', true);
      // Update today's entry in week completion
      final todayIndex = DateTime.now().weekday - 1;
      _weekCompletion[todayIndex] = true;
      await streakPrefs.setString('week_history', jsonEncode(_weekCompletion));
    }
  }

  Future<void> resetCategory(String categoryId) async {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    final prefs = await SharedPreferences.getInstance();
    for (final dhikr in category.adhkar) {
      dhikr.reset();
      await prefs.setInt('count_${dhikr.id}', 0);
    }
    notifyListeners();
  }

  Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (final category in _categories) {
      for (final dhikr in category.adhkar) {
        dhikr.reset();
        await prefs.setInt('count_${dhikr.id}', 0);
      }
    }
    _tasbeehCount = 0;
    await prefs.setInt('tasbeehCount', 0);
    for (final item in _freeDhikrItems) {
      item.reset();
    }
    await _saveFreeDhikrItems();
    notifyListeners();
  }

  AdhkarCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Tasbeeh methods ──

  Future<void> incrementTasbeeh() async {
    if (_tasbeehCount < _tasbeehTarget) {
      _tasbeehCount++;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('tasbeehCount', _tasbeehCount);
      notifyListeners();
    }
  }

  Future<void> resetTasbeeh() async {
    _tasbeehCount = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbeehCount', 0);
    notifyListeners();
  }

  Future<void> setTasbeehTarget(int target) async {
    _tasbeehTarget = target;
    if (_tasbeehCount > target) _tasbeehCount = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbeehTarget', target);
    await prefs.setInt('tasbeehCount', _tasbeehCount);
    notifyListeners();
  }

  Future<void> setTasbeehLabel(String label) async {
    _tasbeehLabel = label;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasbeehLabel', label);
    notifyListeners();
  }

  // ── Free Dhikr list methods ──

  Future<void> addFreeDhikrItem(String text, int target) async {
    final item = FreeDhikrItem(
      id: 'free_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      targetCount: target,
    );
    _freeDhikrItems.add(item);
    await _saveFreeDhikrItems();
    notifyListeners();
  }

  Future<void> removeFreeDhikrItem(String id) async {
    _freeDhikrItems.removeWhere((item) => item.id == id);
    await _saveFreeDhikrItems();
    notifyListeners();
  }

  Future<void> incrementFreeDhikrItem(String id) async {
    final item = _freeDhikrItems.firstWhere((i) => i.id == id);
    item.increment();
    await _saveFreeDhikrItems();
    notifyListeners();
  }

  Future<void> resetFreeDhikrItem(String id) async {
    final item = _freeDhikrItems.firstWhere((i) => i.id == id);
    item.reset();
    await _saveFreeDhikrItems();
    notifyListeners();
  }

  Future<void> _saveFreeDhikrItems() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_freeDhikrItems.map((e) => e.toJson()).toList());
    await prefs.setString('freeDhikrItems', json);
  }

  Future<void> checkDailyReset() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('lastResetDate');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (lastReset != today) {
      await _loadData();
    }
  }

  // ── Settings ──

  Future<void> setVibrationEnabled(bool value) async {
    _vibrationEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrationEnabled', value);
    notifyListeners();
  }
}
