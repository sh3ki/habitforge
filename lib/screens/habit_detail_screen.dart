import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';
import 'add_habit_screen.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Habit habit;

  @override
  void initState() {
    super.initState();
    habit = widget.habit;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleToday() {
    setState(() {
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      if (habit.isCompletedOn(today)) {
        habit.completedDates.removeWhere((d) => d == today);
      } else {
        habit.completedDates.add(today);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCompletedToday = habit.isCompletedOn(DateTime.now());
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: habit.color,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                    onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AddHabitScreen(habit: habit))).then((_) => setState(() {})),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: habit.color,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(habit.icon, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(habit.name,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                                  Text(habit.description.isEmpty ? 'Track your daily habit' : habit.description,
                                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
                                    maxLines: 2),
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
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Stats row
                Container(
                  color: habit.color,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: const BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 16),
                      child: Row(
                        children: [
                          _StatPill(label: 'Current', value: '${habit.currentStreak}', icon: Icons.local_fire_department_rounded, color: habit.color),
                          const SizedBox(width: 10),
                          _StatPill(label: 'Best', value: '${habit.longestStreak}', icon: Icons.star_rounded, color: AppTheme.secondary),
                          const SizedBox(width: 10),
                          _StatPill(label: 'Total', value: '${habit.totalCompletions}', icon: Icons.check_circle_rounded, color: AppTheme.accent),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tab bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: habit.color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      indicator: BoxDecoration(color: habit.color, borderRadius: BorderRadius.circular(10)),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.zero,
                      onTap: (_) => setState(() {}),
                      tabs: const [Tab(text: 'Overview'), Tab(text: 'History'), Tab(text: 'Stats')],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  height: 380,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _OverviewTab(habit: habit),
                      _HistoryTab(habit: habit),
                      _StatsTab(habit: habit),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: _toggleToday,
            icon: Icon(isCompletedToday ? Icons.undo_rounded : Icons.check_rounded, size: 20),
            label: Text(isCompletedToday ? 'Mark as Missed' : 'Complete Today!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompletedToday ? AppTheme.textSecondary : habit.color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatPill({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Habit habit;
  const _OverviewTab({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This Week', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(7, (i) {
              final day = DateTime.now().subtract(Duration(days: 6 - i));
              final done = habit.isCompletedOn(day);
              final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final weekday = dayLabels[day.weekday - 1];
              return Expanded(
                child: Column(
                  children: [
                    Text(weekday, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: done ? habit.color : AppTheme.divider,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: done ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
                    ),
                    const SizedBox(height: 4),
                    Text('${day.day}', style: TextStyle(fontSize: 10, color: done ? habit.color : AppTheme.textSecondary)),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text('Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          _DetailRow(label: 'Frequency', value: habit.frequency.name),
          _DetailRow(label: 'Category', value: habit.category.name),
          _DetailRow(label: 'Target', value: '${habit.targetValue.toInt()} ${habit.unit}'),
          _DetailRow(label: 'Weekly Rate', value: '${(habit.completionRateThisWeek * 100).round()}%'),
          if (habit.reminders.isNotEmpty) _DetailRow(label: 'Reminders', value: habit.reminders.join(', ')),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final Habit habit;
  const _HistoryTab({required this.habit});

  @override
  Widget build(BuildContext context) {
    final sorted = [...habit.completedDates]..sort((a, b) => b.compareTo(a));
    final recent = sorted.take(20).toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: recent.length,
      itemBuilder: (_, i) {
        final d = recent[i];
        final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: habit.color, size: 18),
              const SizedBox(width: 10),
              Text('${dayNames[d.weekday - 1]}, ${d.day}/${d.month}/${d.year}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              const Spacer(),
              Text('Completed', style: TextStyle(fontSize: 11, color: habit.color, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }
}

class _StatsTab extends StatelessWidget {
  final Habit habit;
  const _StatsTab({required this.habit});

  @override
  Widget build(BuildContext context) {
    final data = List.generate(7, (i) {
      final day = DateTime.now().subtract(Duration(days: 6 - i));
      return habit.isCompletedOn(day) ? 1.0 : 0.0;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Progress', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
          const SizedBox(height: 14),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const d = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(d[v.toInt()],
                          style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary));
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: e.value > 0 ? habit.color : AppTheme.divider,
                      width: 28,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                  ],
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _MiniStat(label: 'Total', value: '${habit.totalCompletions}', color: habit.color),
              const SizedBox(width: 10),
              _MiniStat(label: 'This Week', value: '${(habit.completionRateThisWeek * 7).round()}/7', color: AppTheme.accent),
              const SizedBox(width: 10),
              _MiniStat(label: 'Longest', value: '${habit.longestStreak} days', color: AppTheme.secondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
