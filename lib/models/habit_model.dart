import 'package:flutter/material.dart';

enum HabitFrequency { daily, weekly, custom }

enum HabitCategory {
  health,
  fitness,
  mindfulness,
  learning,
  nutrition,
  productivity,
  social,
  creativity,
}

class Habit {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final HabitFrequency frequency;
  final HabitCategory category;
  final String unit; // e.g. "glasses", "minutes", "times"
  final double targetValue;
  final List<DateTime> completedDates;
  final List<String> reminders;
  bool isArchived;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.frequency,
    required this.category,
    this.unit = 'times',
    this.targetValue = 1,
    this.completedDates = const [],
    this.reminders = const [],
    this.isArchived = false,
  });

  bool isCompletedOn(DateTime date) {
    return completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    final sorted = [...completedDates]..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime current = DateTime.now();
    for (int i = 0; i < sorted.length; i++) {
      final diff = current.difference(DateTime(
          sorted[i].year, sorted[i].month, sorted[i].day));
      if (diff.inDays <= 1) {
        streak++;
        current = DateTime(sorted[i].year, sorted[i].month, sorted[i].day)
            .subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  int get longestStreak {
    if (completedDates.isEmpty) return 0;
    final sorted = [...completedDates]..sort((a, b) => a.compareTo(b));
    int max = 1, current = 1;
    for (int i = 1; i < sorted.length; i++) {
      final diff = sorted[i]
          .difference(sorted[i - 1])
          .inDays;
      if (diff == 1) {
        current++;
        if (current > max) max = current;
      } else if (diff > 1) {
        current = 1;
      }
    }
    return max;
  }

  double get completionRateThisWeek {
    int done = 0;
    for (int i = 0; i < 7; i++) {
      final day =
          DateTime.now().subtract(Duration(days: i));
      if (isCompletedOn(day)) done++;
    }
    return done / 7;
  }

  int get totalCompletions => completedDates.length;
}
