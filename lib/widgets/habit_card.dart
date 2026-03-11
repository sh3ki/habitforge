import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;
  final VoidCallback? onToggleToday;
  final bool showProgress;

  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onToggleToday,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCompletedToday = habit.isCompletedOn(DateTime.now());
    final completionRate = habit.completionRateThisWeek;
    final streak = habit.currentStreak;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isCompletedToday ? habit.color.withOpacity(0.06) : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCompletedToday ? habit.color.withOpacity(0.25) : AppTheme.divider,
            width: 1,
          ),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCompletedToday ? habit.color : habit.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(habit.icon, color: isCompletedToday ? Colors.white : habit.color, size: 24),
                    if (isCompletedToday)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 10),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isCompletedToday ? habit.color : AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (streak > 0) ...[
                          Icon(Icons.local_fire_department_rounded, size: 13,
                            color: streak >= 7 ? AppTheme.streakBest : AppTheme.secondary),
                          const SizedBox(width: 2),
                          Text('$streak day streak',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                              color: streak >= 7 ? AppTheme.streakBest : AppTheme.secondary)),
                          const SizedBox(width: 8),
                        ],
                        Text('${habit.totalCompletions} total',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                    if (showProgress) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _WeekDots(habit: habit)),
                          const SizedBox(width: 6),
                          Text('${(completionRate * 100).round()}%',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: habit.color)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Toggle
              GestureDetector(
                onTap: onToggleToday,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isCompletedToday ? habit.color : habit.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompletedToday ? habit.color : habit.color.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    isCompletedToday ? Icons.check_rounded : Icons.add_rounded,
                    color: isCompletedToday ? Colors.white : habit.color,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekDots extends StatelessWidget {
  final Habit habit;
  const _WeekDots({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final day = DateTime.now().subtract(Duration(days: 6 - i));
        final done = habit.isCompletedOn(day);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: done ? habit.color : AppTheme.divider,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class HabitCardCompact extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;

  const HabitCardCompact({super.key, required this.habit, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedOn(DateTime.now());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCompleted ? habit.color.withOpacity(0.08) : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isCompleted ? habit.color.withOpacity(0.2) : AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 10),
            Text(habit.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Text('${habit.currentStreak} days',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: habit.color)),
          ],
        ),
      ),
    );
  }
}
