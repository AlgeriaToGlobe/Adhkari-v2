import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/adhkar_category.dart';
import '../data/sample_data.dart';

class AdhkarProvider extends ChangeNotifier {
  List<AdhkarCategory> _categories = [];
  int _freeDhikrCount = 0;
  String _freeDhikrLabel = 'سبحان الله';
  List<AdhkarCategory> get categories => _categories;
  int get freeDhikrCount => _freeDhikrCount;
  String get freeDhikrLabel => _freeDhikrLabel;

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

    // Check if we need a daily reset
    final lastReset = prefs.getString('lastResetDate');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (lastReset != today) {
      await prefs.setString('lastResetDate', today);
      // Reset all counts for a new day
      for (final category in _categories) {
        for (final dhikr in category.adhkar) {
          await prefs.setInt('count_${dhikr.id}', 0);
        }
      }
    } else {
      // Restore saved counts
      for (final category in _categories) {
        for (final dhikr in category.adhkar) {
          dhikr.currentCount = prefs.getInt('count_${dhikr.id}') ?? 0;
        }
      }
    }

    _freeDhikrCount = prefs.getInt('freeDhikrCount') ?? 0;
    _freeDhikrLabel = prefs.getString('freeDhikrLabel') ?? 'سبحان الله';
    notifyListeners();
  }

  Future<void> incrementDhikr(String categoryId, String dhikrId) async {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    final dhikr = category.adhkar.firstWhere((d) => d.id == dhikrId);

    if (!dhikr.isCompleted) {
      dhikr.increment();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('count_${dhikr.id}', dhikr.currentCount);
      notifyListeners();
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

  Future<void> incrementFreeDhikr() async {
    _freeDhikrCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('freeDhikrCount', _freeDhikrCount);
    notifyListeners();
  }

  Future<void> resetFreeDhikr() async {
    _freeDhikrCount = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('freeDhikrCount', 0);
    notifyListeners();
  }

  Future<void> setFreeDhikrLabel(String label) async {
    _freeDhikrLabel = label;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('freeDhikrLabel', label);
    notifyListeners();
  }

  AdhkarCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
