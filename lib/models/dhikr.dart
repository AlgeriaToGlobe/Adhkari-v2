/// Represents a single Dhikr item with its text, count, and reference.
class Dhikr {
  final String id;
  final String text;
  final int targetCount;
  final String? fadl; // Virtue/reward of this dhikr
  final String? reference; // Hadith reference (e.g., البخاري ١٢٣٤)
  final HadithGrade grade; // Authenticity grade
  final String? notes;

  int currentCount;
  bool get isCompleted => currentCount >= targetCount;
  double get progress =>
      targetCount > 0 ? (currentCount / targetCount).clamp(0.0, 1.0) : 0.0;

  Dhikr({
    required this.id,
    required this.text,
    required this.targetCount,
    this.fadl,
    this.reference,
    this.grade = HadithGrade.sahih,
    this.notes,
    this.currentCount = 0,
  });

  void increment() {
    if (currentCount < targetCount) {
      currentCount++;
    }
  }

  void reset() {
    currentCount = 0;
  }

  Dhikr copyWith({int? currentCount}) {
    return Dhikr(
      id: id,
      text: text,
      targetCount: targetCount,
      fadl: fadl,
      reference: reference,
      grade: grade,
      notes: notes,
      currentCount: currentCount ?? this.currentCount,
    );
  }
}

enum HadithGrade {
  sahih,    // صحيح
  hasan,    // حسن
  daif,     // ضعيف
  mawdu,    // موضوع
  mutawatir, // متواتر
}

extension HadithGradeExtension on HadithGrade {
  String get arabicLabel {
    switch (this) {
      case HadithGrade.sahih:
        return 'صحيح';
      case HadithGrade.hasan:
        return 'حسن';
      case HadithGrade.daif:
        return 'ضعيف';
      case HadithGrade.mawdu:
        return 'موضوع';
      case HadithGrade.mutawatir:
        return 'متواتر';
    }
  }
}
