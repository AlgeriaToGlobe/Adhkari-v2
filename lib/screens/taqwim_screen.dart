import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/hijri_date.dart';
import '../data/islamic_events.dart';
import '../widgets/arch_header.dart';
import '../widgets/diamond_divider.dart';

class TaqwimScreen extends StatefulWidget {
  const TaqwimScreen({super.key});

  @override
  State<TaqwimScreen> createState() => _TaqwimScreenState();
}

class _TaqwimScreenState extends State<TaqwimScreen> {
  late HijriDate _today;
  late int _displayMonth;
  late int _displayYear;

  @override
  void initState() {
    super.initState();
    _today = HijriDate.fromGregorian(DateTime.now());
    _displayMonth = _today.month;
    _displayYear = _today.year;
  }

  void _previousMonth() {
    setState(() {
      _displayMonth--;
      if (_displayMonth < 1) {
        _displayMonth = 12;
        _displayYear--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth++;
      if (_displayMonth > 12) {
        _displayMonth = 1;
        _displayYear++;
      }
    });
  }

  void _goToToday() {
    setState(() {
      _today = HijriDate.fromGregorian(DateTime.now());
      _displayMonth = _today.month;
      _displayYear = _today.year;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final daysInMonth = HijriDate.daysInMonth(_displayYear, _displayMonth);
    final firstDayCol = HijriDate.firstDayColumn(_displayYear, _displayMonth);
    final monthEvents = IslamicEvents.getMonthEvents(_displayMonth);
    final isCurrentMonth =
        _displayMonth == _today.month && _displayYear == _today.year;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              const ArchHeader(
                title: 'التقويم الهجري',
                subtitle: 'المواعيد والمناسبات الإسلامية',
              ),

              // ── Today's Hijri Date Card ──
              Transform.translate(
                offset: const Offset(0, -16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.dividerC(context).withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (dark ? Colors.black : AppColors.brown)
                              .withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: Text(
                            _today.formatted,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textP(context),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldC(context).withValues(alpha: 0.1),
                          ),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            size: 20,
                            color: AppColors.goldC(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Month Navigation ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: dark
                        ? AppColors.darkHeaderGradientSubtle
                        : AppColors.headerGradientSubtle,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Next (right arrow in RTL = previous month visually)
                      IconButton(
                        onPressed: _nextMonth,
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: dark ? AppColors.darkGold : AppColors.gold,
                          size: 28,
                        ),
                      ),
                      // Month/Year display
                      GestureDetector(
                        onTap: isCurrentMonth ? null : _goToToday,
                        child: Column(
                          children: [
                            Text(
                              HijriDate.monthNames[_displayMonth - 1],
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: dark ? AppColors.darkGold : AppColors.gold,
                              ),
                            ),
                            Text(
                              '$_displayYear هـ',
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 14,
                                color:
                                    AppColors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Previous
                      IconButton(
                        onPressed: _previousMonth,
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: dark ? AppColors.darkGold : AppColors.gold,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Calendar Grid ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.dividerC(context).withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (dark ? Colors.black : AppColors.brown)
                            .withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Day name headers
                      _buildDayHeaders(),
                      const SizedBox(height: 8),
                      // Calendar days
                      _buildCalendarGrid(
                        daysInMonth,
                        firstDayCol,
                        monthEvents,
                        isCurrentMonth,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Islamic Events for the Month ──
              if (monthEvents.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المناسبات الإسلامية',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textP(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._buildEventCards(monthEvents),
                    ],
                  ),
                ),
              ],

              if (monthEvents.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.dividerC(context).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'لا توجد مناسبات إسلامية في هذا الشهر',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        color: AppColors.textS(context).withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 8),
              const DiamondDivider(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayHeaders() {
    return Row(
      textDirection: TextDirection.rtl,
      children: List.generate(7, (index) {
        // In RTL, index 0 is rightmost = Saturday
        final isFriday = index == 6;
        return Expanded(
          child: Center(
            child: Text(
              HijriDate.dayAbbreviations[index],
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isFriday
                    ? AppColors.goldC(context)
                    : AppColors.textS(context),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid(
    int daysInMonth,
    int firstDayCol,
    Map<int, List<IslamicEvent>> monthEvents,
    bool isCurrentMonth,
  ) {
    final accentGold = AppColors.goldC(context);
    // Build rows of 7 cells each
    final List<Widget> rows = [];
    int dayCounter = 1;

    // Number of rows needed
    final totalCells = firstDayCol + daysInMonth;
    final numRows = (totalCells / 7).ceil();

    for (int row = 0; row < numRows; row++) {
      final List<Widget> cells = [];
      for (int col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;
        if (cellIndex < firstDayCol || dayCounter > daysInMonth) {
          // Empty cell
          cells.add(const Expanded(child: SizedBox(height: 44)));
        } else {
          final day = dayCounter;
          final hasEvent = monthEvents.containsKey(day);
          final isToday = isCurrentMonth && day == _today.day;
          final isFriday = col == 6;

          cells.add(
            Expanded(
              child: GestureDetector(
                onTap: hasEvent
                    ? () => _showDayEvents(day, monthEvents[day]!)
                    : null,
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isToday
                        ? accentGold
                        : hasEvent
                            ? accentGold.withValues(alpha: 0.08)
                            : null,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday
                        ? null
                        : hasEvent
                            ? Border.all(
                                color:
                                    accentGold.withValues(alpha: 0.3),
                              )
                            : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 15,
                          fontWeight: isToday || hasEvent
                              ? FontWeight.w700
                              : FontWeight.normal,
                          color: isToday
                              ? AppColors.white
                              : isFriday
                                  ? accentGold
                                  : AppColors.textP(context),
                          height: 1.2,
                        ),
                      ),
                      if (hasEvent && !isToday)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentGold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }
      rows.add(Row(
        textDirection: TextDirection.rtl,
        children: cells,
      ));
    }

    return Column(children: rows);
  }

  List<Widget> _buildEventCards(Map<int, List<IslamicEvent>> monthEvents) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);
    final List<Widget> cards = [];
    final sortedDays = monthEvents.keys.toList()..sort();

    for (final day in sortedDays) {
      final events = monthEvents[day]!;
      for (final event in events) {
        cards.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentGold.withValues(alpha: 0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (dark ? Colors.black : AppColors.brown)
                        .withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day number badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accentGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: accentGold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: accentGold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Event details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textP(context),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event.description,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 13,
                            color: AppColors.textS(context),
                            height: 1.5,
                          ),
                        ),
                        if (event.reference != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            event.reference!,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 11,
                              color: accentGold.withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return cards;
  }

  void _showDayEvents(int day, List<IslamicEvent> events) {
    final accentGold = AppColors.goldC(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.scaffold(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.dividerC(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Date title
                Text(
                  '$day ${HijriDate.monthNames[_displayMonth - 1]} $_displayYear هـ',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textP(context),
                  ),
                ),
                const SizedBox(height: 12),
                // Events
                ...events.map((event) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accentGold.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textP(context),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.description,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 14,
                                color: AppColors.textS(context),
                                height: 1.5,
                              ),
                            ),
                            if (event.reference != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 14,
                                    color: accentGold
                                        .withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      event.reference!,
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 12,
                                        color: accentGold
                                            .withValues(alpha: 0.8),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
