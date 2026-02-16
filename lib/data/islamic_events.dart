/// Islamic events and important dates based on authentic Sunni sources.
///
/// Only includes dates with strong basis in the Quran and authentic Sunnah.
/// No bid'ah (innovated) celebrations are included.
class IslamicEvent {
  final String title;
  final String description;
  final String? reference;

  const IslamicEvent({
    required this.title,
    required this.description,
    this.reference,
  });
}

class IslamicEvents {
  IslamicEvents._();

  /// Get events for a specific Hijri month and day.
  /// Key format: "month-day" (e.g., "1-10" for 10 Muharram).
  static List<IslamicEvent> getEvents(int month, int day) {
    return _events['$month-$day'] ?? [];
  }

  /// Get all events for a specific Hijri month.
  static Map<int, List<IslamicEvent>> getMonthEvents(int month) {
    final result = <int, List<IslamicEvent>>{};
    for (final entry in _events.entries) {
      final parts = entry.key.split('-');
      final m = int.parse(parts[0]);
      final d = int.parse(parts[1]);
      if (m == month) {
        result[d] = entry.value;
      }
    }
    return result;
  }

  /// All Islamic events indexed by "month-day".
  static const Map<String, List<IslamicEvent>> _events = {
    // ══════════════════════════════════════════════
    // محرم - Muharram (Month 1)
    // ══════════════════════════════════════════════
    '1-1': [
      IslamicEvent(
        title: 'رأس السنة الهجرية',
        description: 'بداية العام الهجري الجديد',
      ),
    ],
    '1-9': [
      IslamicEvent(
        title: 'تاسوعاء',
        description: 'يُستحب صيامه مع يوم عاشوراء',
        reference: 'صحيح مسلم ١١٣٤',
      ),
    ],
    '1-10': [
      IslamicEvent(
        title: 'يوم عاشوراء',
        description: 'يُستحب صيامه، يُكفّر ذنوب سنة ماضية',
        reference: 'صحيح مسلم ١١٦٢',
      ),
    ],

    // ══════════════════════════════════════════════
    // رمضان - Ramadan (Month 9)
    // ══════════════════════════════════════════════
    '9-1': [
      IslamicEvent(
        title: 'بداية شهر رمضان',
        description: 'شهر الصيام والقيام وتلاوة القرآن',
        reference: 'سورة البقرة ١٨٥',
      ),
    ],
    '9-21': [
      IslamicEvent(
        title: 'ليالي الوتر - العشر الأواخر',
        description: 'تُلتمس فيها ليلة القدر',
        reference: 'صحيح البخاري ٢٠٢٠',
      ),
    ],
    '9-23': [
      IslamicEvent(
        title: 'ليالي الوتر - العشر الأواخر',
        description: 'تُلتمس فيها ليلة القدر',
        reference: 'صحيح البخاري ٢٠٢٠',
      ),
    ],
    '9-25': [
      IslamicEvent(
        title: 'ليالي الوتر - العشر الأواخر',
        description: 'تُلتمس فيها ليلة القدر',
        reference: 'صحيح البخاري ٢٠٢٠',
      ),
    ],
    '9-27': [
      IslamicEvent(
        title: 'ليالي الوتر - العشر الأواخر',
        description: 'تُلتمس فيها ليلة القدر، وهي أرجى الليالي',
        reference: 'صحيح البخاري ٢٠٢٠، صحيح مسلم ١١٦٥',
      ),
    ],
    '9-29': [
      IslamicEvent(
        title: 'ليالي الوتر - العشر الأواخر',
        description: 'تُلتمس فيها ليلة القدر',
        reference: 'صحيح البخاري ٢٠٢٠',
      ),
    ],

    // ══════════════════════════════════════════════
    // شوال - Shawwal (Month 10)
    // ══════════════════════════════════════════════
    '10-1': [
      IslamicEvent(
        title: 'عيد الفطر المبارك',
        description: 'يحرم صيامه، وتُشرع فيه صلاة العيد والتكبير',
        reference: 'صحيح البخاري ١٩٩٠',
      ),
    ],

    // ══════════════════════════════════════════════
    // ذو الحجة - Dhul Hijjah (Month 12)
    // ══════════════════════════════════════════════
    '12-1': [
      IslamicEvent(
        title: 'بداية عشر ذي الحجة',
        description:
            'أفضل أيام الدنيا، يُستحب فيها الإكثار من العمل الصالح والذكر',
        reference: 'صحيح البخاري ٩٦٩',
      ),
    ],
    '12-8': [
      IslamicEvent(
        title: 'يوم التروية',
        description: 'بداية مناسك الحج، يُستحب صيامه لغير الحاج',
      ),
    ],
    '12-9': [
      IslamicEvent(
        title: 'يوم عرفة',
        description: 'أفضل الأيام، صيامه يُكفّر سنة ماضية وسنة آتية لغير الحاج',
        reference: 'صحيح مسلم ١١٦٢',
      ),
    ],
    '12-10': [
      IslamicEvent(
        title: 'عيد الأضحى المبارك',
        description: 'أعظم الأيام عند الله، يحرم صيامه، وتُشرع الأضحية',
        reference: 'سنن أبي داود ١٧٦٥',
      ),
    ],
    '12-11': [
      IslamicEvent(
        title: 'أيام التشريق',
        description: 'أيام أكل وشرب وذكر لله، يحرم صيامها',
        reference: 'صحيح مسلم ١١٤١',
      ),
    ],
    '12-12': [
      IslamicEvent(
        title: 'أيام التشريق',
        description: 'أيام أكل وشرب وذكر لله، يحرم صيامها',
        reference: 'صحيح مسلم ١١٤١',
      ),
    ],
    '12-13': [
      IslamicEvent(
        title: 'آخر أيام التشريق',
        description: 'آخر أيام التشريق، يحرم صيامها',
        reference: 'صحيح مسلم ١١٤١',
      ),
    ],
  };
}
