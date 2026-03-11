import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/habit_data.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';
import 'habit_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final habits = HabitData.habits;
    final doneToday = habits.where((h) => h.isCompletedOn(_selectedDate)).toList();
    final missedToday = habits.where((h) => !h.isCompletedOn(_selectedDate) && !h.isArchived).toList();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: const Text('Calendar', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: AppTheme.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Month nav
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, color: AppTheme.textPrimary),
                onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1)),
              ),
              Text(DateFormat('MMMM yyyy').format(_focusedMonth),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.textPrimary),
                onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Weekday headers
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) => Expanded(
              child: Center(child: Text(d, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
            )).toList(),
          ),
          const SizedBox(height: 6),

          // Calendar grid
          _buildCalendarGrid(habits),
          const SizedBox(height: 20),

          // Selected day info
          Text(DateFormat('EEEE, MMMM d').format(_selectedDate),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('${doneToday.length} of ${habits.where((h) => !h.isArchived).length} completed',
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 14),

          if (doneToday.isNotEmpty) ...[
            const Text('Completed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.accent)),
            const SizedBox(height: 8),
            ...doneToday.map((h) => _HabitRow(habit: h, done: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: h))))),
            const SizedBox(height: 14),
          ],
          if (missedToday.isNotEmpty) ...[
            const Text('Missed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            ...missedToday.map((h) => _HabitRow(habit: h, done: false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: h))))),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(List<Habit> habits) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    int startWeekday = firstDay.weekday; // 1=Monday

    List<Widget> rows = [];
    List<Widget> currentRow = [];

    // Pad start
    for (int i = 1; i < startWeekday; i++) {
      currentRow.add(const Expanded(child: SizedBox(height: 42)));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final completions = habits.where((h) => h.isCompletedOn(date)).length;
      final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
      final isToday = date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day;

      currentRow.add(Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            height: 42,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isToday && !isSelected ? Border.all(color: AppTheme.secondary, width: 1.5) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$day',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
                if (completions > 0)
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : _completionColor(completions, habits.length),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ));

      if (currentRow.length == 7) {
        rows.add(Row(children: currentRow));
        currentRow = [];
      }
    }

    // Pad end
    while (currentRow.length < 7) {
      currentRow.add(const Expanded(child: SizedBox(height: 42)));
    }
    if (currentRow.isNotEmpty) rows.add(Row(children: currentRow));

    return Column(children: rows);
  }

  Color _completionColor(int count, int total) {
    final ratio = count / total;
    if (ratio >= 0.75) return AppTheme.accent;
    if (ratio >= 0.4) return AppTheme.secondary;
    return AppTheme.textSecondary;
  }
}

class _HabitRow extends StatelessWidget {
  final Habit habit;
  final bool done;
  final VoidCallback? onTap;
  const _HabitRow({required this.habit, required this.done, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: habit.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(habit.icon, color: habit.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(habit.name,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: done ? AppTheme.textPrimary : AppTheme.textSecondary,
                )),
            ),
            Icon(done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: done ? AppTheme.accent : AppTheme.divider, size: 20),
          ],
        ),
      ),
    );
  }
}
