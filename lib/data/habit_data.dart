import 'package:flutter/material.dart';
import '../models/habit_model.dart';

DateTime _daysAgo(int days) => DateTime.now().subtract(Duration(days: days));

List<DateTime> _buildDates(List<int> daysAgoList) {
  return daysAgoList.map((d) => DateTime(_daysAgo(d).year, _daysAgo(d).month, _daysAgo(d).day)).toList();
}

class HabitData {
  static final List<Habit> habits = [
    Habit(
      id: '1',
      name: 'Drink 8 Glasses of Water',
      description: 'Stay hydrated throughout the day for optimal health and energy.',
      icon: Icons.local_drink_rounded,
      color: const Color(0xFF5C6B8A),
      frequency: HabitFrequency.daily,
      category: HabitCategory.health,
      unit: 'glasses',
      targetValue: 8,
      completedDates: _buildDates([0, 1, 2, 3, 5, 6, 8, 9, 10, 12, 13, 14, 15, 16, 18, 19, 20]),
      reminders: ['8:00 AM', '12:00 PM', '6:00 PM'],
    ),
    Habit(
      id: '2',
      name: 'Exercise 30 Minutes',
      description: 'Daily physical exercise — cardio, strength training, yoga, or any heart-pumping activity.',
      icon: Icons.fitness_center_rounded,
      color: const Color(0xFFE07A5F),
      frequency: HabitFrequency.daily,
      category: HabitCategory.fitness,
      unit: 'minutes',
      targetValue: 30,
      completedDates: _buildDates([0, 1, 3, 4, 5, 7, 8, 10, 11, 12, 14, 15, 17]),
      reminders: ['7:00 AM'],
    ),
    Habit(
      id: '3',
      name: 'Read 20 Minutes',
      description: 'Expand knowledge and improve focus by reading books or articles for at least 20 minutes.',
      icon: Icons.menu_book_rounded,
      color: const Color(0xFF9B5DE5),
      frequency: HabitFrequency.daily,
      category: HabitCategory.learning,
      unit: 'minutes',
      targetValue: 20,
      completedDates: _buildDates([0, 1, 2, 4, 5, 6, 7, 9, 10, 11, 13, 14, 16, 17, 18, 20]),
      reminders: ['9:00 PM'],
    ),
    Habit(
      id: '4',
      name: 'Morning Meditation',
      description: 'Start your day with 10 minutes of mindfulness to reduce stress and improve focus.',
      icon: Icons.self_improvement_rounded,
      color: const Color(0xFF81B29A),
      frequency: HabitFrequency.daily,
      category: HabitCategory.mindfulness,
      unit: 'minutes',
      targetValue: 10,
      completedDates: _buildDates([0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 12, 13]),
      reminders: ['6:30 AM'],
    ),
    Habit(
      id: '5',
      name: 'No Sugar Today',
      description: 'Avoid refined sugar in food and drinks. Choose natural alternatives.',
      icon: Icons.no_food_rounded,
      color: const Color(0xFFD4A373),
      frequency: HabitFrequency.daily,
      category: HabitCategory.nutrition,
      unit: 'times',
      targetValue: 1,
      completedDates: _buildDates([1, 2, 4, 5, 7, 8, 9, 11, 13, 14]),
      reminders: [],
    ),
    Habit(
      id: '6',
      name: 'Journal Entry',
      description: 'Write a short daily journal entry — what went well and one thing to improve.',
      icon: Icons.edit_note_rounded,
      color: const Color(0xFF3D405B),
      frequency: HabitFrequency.daily,
      category: HabitCategory.mindfulness,
      unit: 'entry',
      targetValue: 1,
      completedDates: _buildDates([0, 1, 3, 5, 6, 8, 10, 12, 13, 15, 17, 18]),
      reminders: ['10:00 PM'],
    ),
    Habit(
      id: '7',
      name: 'Learn Spanish 15 min',
      description: 'Practice vocabulary, grammar, and conversation skills using study materials.',
      icon: Icons.translate_rounded,
      color: const Color(0xFF6D8B74),
      frequency: HabitFrequency.daily,
      category: HabitCategory.learning,
      unit: 'minutes',
      targetValue: 15,
      completedDates: _buildDates([0, 2, 3, 5, 7, 8, 10, 12, 14, 16]),
      reminders: ['7:30 PM'],
    ),
    Habit(
      id: '8',
      name: 'Sleep by 11 PM',
      description: 'Maintain a consistent sleep schedule for 7-8 hours of quality rest.',
      icon: Icons.bedtime_rounded,
      color: const Color(0xFFE76F51),
      frequency: HabitFrequency.daily,
      category: HabitCategory.health,
      unit: 'times',
      targetValue: 1,
      completedDates: _buildDates([1, 2, 3, 5, 6, 8, 9, 11, 12, 14, 15]),
      reminders: ['10:30 PM'],
    ),
  ];

  static Map<String, int> get weeklyStats {
    final now = DateTime.now();
    final map = <String, int>{};
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      int count = 0;
      for (final habit in habits) {
        if (habit.isCompletedOn(day)) count++;
      }
      final weekday = days[day.weekday - 1];
      map[weekday] = count;
    }
    return map;
  }

  static List<Map<String, dynamic>> get monthlyCompletionData {
    final now = DateTime.now();
    return List.generate(30, (i) {
      final day = now.subtract(Duration(days: 29 - i));
      int count = 0;
      for (final habit in habits) {
        if (habit.isCompletedOn(day)) count++;
      }
      return {'day': day.day, 'count': count, 'total': habits.length, 'date': day};
    });
  }
}
