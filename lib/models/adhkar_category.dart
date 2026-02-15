import 'package:flutter/material.dart';
import 'dhikr.dart';

/// Represents a category of Adhkar (e.g., Morning, Evening)
class AdhkarCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Dhikr> adhkar;

  const AdhkarCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.adhkar,
  });

  int get totalCount => adhkar.length;
  int get completedCount => adhkar.where((d) => d.isCompleted).length;
  bool get isAllCompleted => completedCount == totalCount;
  double get progress =>
      totalCount > 0 ? completedCount / totalCount : 0.0;
}
