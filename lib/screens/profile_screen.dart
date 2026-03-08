import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  bool _dailyReminder = true;
  bool _weeklyReport = false;
  String _reminderTime = '08:00 AM';

  @override
  Widget build(BuildContext context) {
    final habits = MockData.habits;
    final totalCompletions =
        habits.fold(0, (s, h) => s + h.totalCompletions);
    final bestStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
    final activeCurrent = habits.where((h) => h.currentStreak > 0).length;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: ListView(
        children: [
          // Profile header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                child: Column(
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.edit_rounded,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('Edit',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Avatar + name
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.25),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 3),
                          ),
                          child: const Center(
                            child: Text(
                              'JR',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jordan',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'jordan@example.com',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '🔥 Habit Builder',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stats grid
          Transform.translate(
            offset: const Offset(0, -16),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppTheme.cardShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _QuickStat(
                      value: '${habits.length}',
                      label: 'Habits',
                      icon: Icons.loop_rounded,
                      color: AppTheme.primary),
                  _Divider(),
                  _QuickStat(
                      value: '$totalCompletions',
                      label: 'Completions',
                      icon: Icons.check_circle_rounded,
                      color: AppTheme.accent),
                  _Divider(),
                  _QuickStat(
                      value: '$bestStreak',
                      label: 'Best Streak',
                      icon: Icons.local_fire_department_rounded,
                      color: AppTheme.secondary),
                  _Divider(),
                  _QuickStat(
                      value: '$activeCurrent',
                      label: 'On Fire',
                      icon: Icons.bolt_rounded,
                      color: Colors.deepOrange),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Achievements
                const Text(
                  'Achievements',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                  children: [
                    _AchievementBadge(
                        emoji: '🔥',
                        label: '7 Day\nStreak',
                        unlocked: bestStreak >= 7),
                    _AchievementBadge(
                        emoji: '⭐',
                        label: '30 Day\nStreak',
                        unlocked: bestStreak >= 30),
                    _AchievementBadge(
                        emoji: '💪',
                        label: '50+\nDone',
                        unlocked: totalCompletions >= 50),
                    _AchievementBadge(
                        emoji: '🎯',
                        label: '5+\nHabits',
                        unlocked: habits.length >= 5),
                    _AchievementBadge(
                        emoji: '🏆',
                        label: 'Perfect\nWeek',
                        unlocked:
                            habits.any((h) => h.completionRateThisWeek == 1)),
                    _AchievementBadge(
                        emoji: '🌟',
                        label: '100+\nDone',
                        unlocked: totalCompletions >= 100),
                  ],
                ),

                const SizedBox(height: 24),

                // Settings section
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Column(
                    children: [
                      _ToggleSetting(
                        icon: Icons.notifications_rounded,
                        color: AppTheme.primary,
                        label: 'Push Notifications',
                        subtitle: 'Get reminders for your habits',
                        value: _notifications,
                        onChanged: (v) => setState(() => _notifications = v),
                      ),
                      const Divider(
                          height: 1,
                          color: AppTheme.divider,
                          indent: 48),
                      _ToggleSetting(
                        icon: Icons.alarm_rounded,
                        color: AppTheme.secondary,
                        label: 'Daily Reminder',
                        subtitle: 'Remind me every day',
                        value: _dailyReminder,
                        onChanged: (v) =>
                            setState(() => _dailyReminder = v),
                      ),
                      const Divider(
                          height: 1,
                          color: AppTheme.divider,
                          indent: 48),
                      _TapSetting(
                        icon: Icons.schedule_rounded,
                        color: AppTheme.accent,
                        label: 'Reminder Time',
                        subtitle: _reminderTime,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              final h = time.hourOfPeriod == 0
                                  ? 12
                                  : time.hourOfPeriod;
                              final m = time.minute
                                  .toString()
                                  .padLeft(2, '0');
                              final p = time.period == DayPeriod.am
                                  ? 'AM'
                                  : 'PM';
                              _reminderTime = '$h:$m $p';
                            });
                          }
                        },
                      ),
                      const Divider(
                          height: 1,
                          color: AppTheme.divider,
                          indent: 48),
                      _ToggleSetting(
                        icon: Icons.bar_chart_rounded,
                        color: Colors.purple,
                        label: 'Weekly Report',
                        subtitle: 'Summary every Sunday',
                        value: _weeklyReport,
                        onChanged: (v) =>
                            setState(() => _weeklyReport = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Column(
                    children: [
                      _TapSetting(
                        icon: Icons.backup_rounded,
                        color: Colors.blueGrey,
                        label: 'Backup & Restore',
                        subtitle: 'Last backed up: Today',
                        onTap: () {},
                      ),
                      const Divider(
                          height: 1,
                          color: AppTheme.divider,
                          indent: 48),
                      _TapSetting(
                        icon: Icons.info_outline_rounded,
                        color: AppTheme.textSecondary,
                        label: 'About HabitForge',
                        subtitle: 'Version 1.0.0',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // App logo footer
                Center(
                  child: Column(
                    children: [
                      const AppLogo(size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'HabitForge v1.0.0',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color:
                              AppTheme.textSecondary.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppTheme.divider);
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _QuickStat(
      {required this.value,
      required this.label,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: color)),
        Text(label,
            style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                color: AppTheme.textSecondary)),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String emoji;
  final String label;
  final bool unlocked;
  const _AchievementBadge(
      {required this.emoji,
      required this.label,
      required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: unlocked
            ? AppTheme.secondary.withOpacity(0.1)
            : AppTheme.divider.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked
              ? AppTheme.secondary.withOpacity(0.4)
              : AppTheme.divider,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unlocked ? emoji : '🔒',
            style: TextStyle(
                fontSize: 24,
                color: unlocked ? null : Colors.grey.withOpacity(0.4)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: unlocked
                  ? AppTheme.textPrimary
                  : AppTheme.textSecondary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleSetting(
      {required this.icon,
      required this.color,
      required this.label,
      required this.subtitle,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTheme.textPrimary)),
                Text(subtitle,
                    style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

class _TapSetting extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _TapSetting(
      {required this.icon,
      required this.color,
      required this.label,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppTheme.textPrimary)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
