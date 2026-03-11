import 'package:flutter/material.dart';
import '../data/habit_data.dart';
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

  @override
  Widget build(BuildContext context) {
    final habits = HabitData.habits;
    final totalCompletions = habits.fold(0, (s, h) => s + h.totalCompletions);
    final bestStreak = habits.isEmpty ? 0 : habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
    final activeCurrent = habits.where((h) => h.currentStreak > 0).length;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: ListView(
        children: [
          // Profile header
          Container(
            color: AppTheme.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Profile',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.white)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('Edit', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.6), width: 2.5),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://randomuser.me/api/portraits/men/32.jpg',
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.white.withOpacity(0.2),
                                  child: const Center(
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.white.withOpacity(0.2),
                                child: const Center(
                                  child: Text('JR', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Jordan',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white)),
                              const Text('jordan@example.com',
                                style: TextStyle(fontSize: 13, color: Colors.white70)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_fire_department_rounded, color: AppTheme.secondary, size: 14),
                                    SizedBox(width: 3),
                                    Text('Habit Builder',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.white)),
                                  ],
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

          // Stats
          Transform.translate(
            offset: const Offset(0, -16),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [AppTheme.cardShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _QuickStat(value: '${habits.length}', label: 'Habits', icon: Icons.loop_rounded, color: AppTheme.primary),
                  _Div(),
                  _QuickStat(value: '$totalCompletions', label: 'Done', icon: Icons.check_circle_rounded, color: AppTheme.accent),
                  _Div(),
                  _QuickStat(value: '$bestStreak', label: 'Best', icon: Icons.local_fire_department_rounded, color: AppTheme.secondary),
                  _Div(),
                  _QuickStat(value: '$activeCurrent', label: 'Active', icon: Icons.bolt_rounded, color: const Color(0xFFE76F51)),
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
                const Text('Achievements',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                  children: [
                    _AchievementBadge(icon: Icons.local_fire_department_rounded, label: '7 Day\nStreak', unlocked: bestStreak >= 7, color: AppTheme.secondary),
                    _AchievementBadge(icon: Icons.star_rounded, label: '30 Day\nStreak', unlocked: bestStreak >= 30, color: const Color(0xFFD4A373)),
                    _AchievementBadge(icon: Icons.fitness_center_rounded, label: '50+\nDone', unlocked: totalCompletions >= 50, color: AppTheme.primary),
                    _AchievementBadge(icon: Icons.track_changes_rounded, label: '5+\nHabits', unlocked: habits.length >= 5, color: AppTheme.accent),
                    _AchievementBadge(icon: Icons.emoji_events_rounded, label: 'Perfect\nWeek', unlocked: habits.any((h) => h.completionRateThisWeek == 1), color: const Color(0xFF9B5DE5)),
                    _AchievementBadge(icon: Icons.auto_awesome_rounded, label: 'All Star', unlocked: totalCompletions >= 100, color: const Color(0xFFE76F51)),
                  ],
                ),
                const SizedBox(height: 24),

                // Settings
                const Text('Settings',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
                const SizedBox(height: 12),
                _Toggle(icon: Icons.notifications_rounded, label: 'Notifications', value: _notifications, onChanged: (v) => setState(() => _notifications = v)),
                _Toggle(icon: Icons.alarm_rounded, label: 'Daily Reminder', value: _dailyReminder, onChanged: (v) => setState(() => _dailyReminder = v)),
                _Toggle(icon: Icons.summarize_rounded, label: 'Weekly Report', value: _weeklyReport, onChanged: (v) => setState(() => _weeklyReport = v)),
                const SizedBox(height: 14),
                _MenuItem(icon: Icons.color_lens_rounded, label: 'Theme'),
                _MenuItem(icon: Icons.download_rounded, label: 'Export Data'),
                _MenuItem(icon: Icons.info_rounded, label: 'About'),
                _MenuItem(icon: Icons.logout_rounded, label: 'Sign Out'),
                const SizedBox(height: 30),

                // App logo footer
                Center(child: AppLogo(size: 32, showText: true)),
                const SizedBox(height: 6),
                const Center(child: Text('v1.0.0', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _QuickStat({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
      ],
    );
  }
}

class _Div extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppTheme.divider);
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool unlocked;
  final Color color;
  const _AchievementBadge({required this.icon, required this.label, required this.unlocked, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked ? color.withOpacity(0.08) : AppTheme.divider.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: unlocked ? color.withOpacity(0.2) : Colors.transparent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: unlocked ? color : AppTheme.textSecondary.withOpacity(0.4), size: 26),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
              color: unlocked ? AppTheme.textPrimary : AppTheme.textSecondary.withOpacity(0.5))),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.icon, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
          Switch(value: value, onChanged: onChanged, activeColor: AppTheme.secondary),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
          const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 20),
        ],
      ),
    );
  }
}
