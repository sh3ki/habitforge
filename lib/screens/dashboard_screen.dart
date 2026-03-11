import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/habit_data.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';
import '../widgets/habit_card.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final habits = HabitData.habits;
    final todayDone = habits.where((h) => h.isCompletedOn(DateTime.now())).length;
    final totalActive = habits.where((h) => !h.isArchived).length;
    final bestStreak = habits.isEmpty ? 0 : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHabitScreen())).then((_) => setState(() {})),
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Unique gradient header with logo
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A6E), Color(0xFF7B2FBE)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A1A6E).withOpacity(0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_greeting(),
                          style: const TextStyle(fontSize: 13, color: Colors.white70)),
                        const SizedBox(height: 3),
                        const Text('Jordan',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 12),
                              const SizedBox(width: 5),
                              Text(DateFormat('EEEE, MMM d').format(DateTime.now()),
                                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1)],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/habitforge logo.png', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Today's progress banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Progress",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70)),
                        const SizedBox(height: 6),
                        Text('$todayDone / $totalActive completed',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 8),
                        // Progress bar
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: totalActive > 0 ? todayDone / totalActive : 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.secondary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: AppTheme.secondary, size: 22),
                        Text('$bestStreak',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick stats row
            Row(
              children: [
                _StatChip(icon: Icons.check_circle_rounded, label: 'Done', value: '$todayDone', color: AppTheme.accent),
                const SizedBox(width: 10),
                _StatChip(icon: Icons.pending_rounded, label: 'Pending', value: '${totalActive - todayDone}', color: AppTheme.secondary),
                const SizedBox(width: 10),
                _StatChip(icon: Icons.loop_rounded, label: 'Active', value: '$totalActive', color: AppTheme.primary),
              ],
            ),
            const SizedBox(height: 24),

            // Section label
            const Text("Today's Habits",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(height: 14),

            // Habit list
            ...habits.where((h) => !h.isArchived).map((habit) => HabitCard(
              habit: habit,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: habit))).then((_) => setState(() {})),
              onToggleToday: () {
                setState(() {
                  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                  if (habit.isCompletedOn(today)) {
                    habit.completedDates.removeWhere((d) => d.year == today.year && d.month == today.month && d.day == today.day);
                  } else {
                    habit.completedDates.add(today);
                  }
                });
              },
            )),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
