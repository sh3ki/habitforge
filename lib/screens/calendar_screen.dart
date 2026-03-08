import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/mock_data.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';
import 'habit_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Habit> _getHabitsCompletedOn(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return MockData.habits
        .where((h) => h.completedDates
            .any((d) => DateTime(d.year, d.month, d.day) == normalized))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedDay ?? DateTime.now();
    final completedOnDay = _getHabitsCompletedOn(selected);
    final allCount = MockData.habits.length;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: const Text(
          'Calendar',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${MockData.habits.length} habits',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppTheme.cardShadow],
            ),
            child: TableCalendar<Habit>(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              eventLoader: _getHabitsCompletedOn,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return const SizedBox.shrink();
                  return Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: events
                          .take(3)
                          .map((h) => Container(
                                width: 5,
                                height: 5,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: h.color,
                                  shape: BoxShape.circle,
                                ),
                              ))
                          .toList(),
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primary, width: 2),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: const TextStyle(
                    color: AppTheme.primary,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700),
                selectedDecoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700),
                defaultTextStyle: const TextStyle(
                    color: AppTheme.textPrimary, fontFamily: 'Nunito'),
                weekendTextStyle: const TextStyle(
                    color: AppTheme.primary, fontFamily: 'Nunito'),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                titleTextStyle: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.textPrimary),
                formatButtonDecoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                formatButtonTextStyle:
                    TextStyle(color: Colors.white, fontFamily: 'Nunito'),
                leftChevronIcon: Icon(Icons.chevron_left_rounded,
                    color: AppTheme.primary),
                rightChevronIcon: Icon(Icons.chevron_right_rounded,
                    color: AppTheme.primary),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary),
                weekendStyle: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Selected day info bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  _formatDate(selected),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: completedOnDay.isNotEmpty
                        ? AppTheme.accent.withOpacity(0.1)
                        : AppTheme.divider,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${completedOnDay.length}/$allCount completed',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: completedOnDay.isNotEmpty
                          ? AppTheme.accent
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Habits list for selected day
          Expanded(
            child: completedOnDay.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_rounded,
                            size: 48,
                            color: AppTheme.textSecondary.withOpacity(0.3)),
                        const SizedBox(height: 8),
                        const Text(
                          'No habits completed\non this day',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              color: AppTheme.textSecondary,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: completedOnDay.length,
                    itemBuilder: (_, i) {
                      final h = completedOnDay[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  HabitDetailScreen(habit: h)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.divider),
                            boxShadow: [AppTheme.cardShadow],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: h.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(h.icon,
                                    color: h.color, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(h.name,
                                        style: const TextStyle(
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: AppTheme.textPrimary)),
                                    Text(
                                        'Streak: ${h.currentStreak} 🔥',
                                        style: const TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 12,
                                            color:
                                                AppTheme.textSecondary)),
                                  ],
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: h.color,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    if (isSameDay(d, now)) return 'Today, ${months[d.month - 1]} ${d.day}';
    if (isSameDay(d, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday, ${months[d.month - 1]} ${d.day}';
    }
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }
}
