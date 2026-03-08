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
          color: isCompletedToday
              ? habit.color.withOpacity(0.06)
              : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompletedToday
                ? habit.color.withOpacity(0.3)
                : AppTheme.divider,
            width: isCompletedToday ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isCompletedToday
                      ? habit.color
                      : habit.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      habit.icon,
                      color: isCompletedToday ? Colors.white : habit.color,
                      size: 26,
                    ),
                    if (isCompletedToday)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 11),
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
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isCompletedToday
                            ? habit.color
                            : AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (streak > 0) ...[
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 13,
                            color: streak >= 7
                                ? AppTheme.streakBest
                                : AppTheme.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$streak day streak',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: streak >= 7
                                  ? AppTheme.streakBest
                                  : AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '${habit.totalCompletions} total',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (showProgress) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _WeekDots(habit: habit),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${(completionRate * 100).round()}%',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: habit.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Check button
              GestureDetector(
                onTap: onToggleToday,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompletedToday
                        ? habit.color
                        : habit.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompletedToday
                          ? habit.color
                          : habit.color.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    isCompletedToday
                        ? Icons.check_rounded
                        : Icons.add_rounded,
                    color: isCompletedToday ? Colors.white : habit.color,
                    size: 20,
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
        final isCompleted = habit.isCompletedOn(day);
        final isToday = i == 6;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? habit.color : AppTheme.divider,
              border: isToday
                  ? Border.all(
                      color: habit.color.withOpacity(0.5), width: 1.5)
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

class StreakBadge extends StatelessWidget {
  final int streak;
  final Color color;

  const StreakBadge({super.key, required this.streak, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
