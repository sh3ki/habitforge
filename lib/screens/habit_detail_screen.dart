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

class _HabitDetailScreenState extends State<HabitDetailScreen>
    with SingleTickerProviderStateMixin {
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
      final today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
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
                    icon: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 18),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddHabitScreen(habit: habit),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      habit.color,
                      habit.color.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
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
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(habit.icon,
                                  color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    habit.name,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    habit.description.isEmpty
                                        ? 'Track your daily habit'
                                        : habit.description,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 12,
                                      color:
                                          Colors.white.withOpacity(0.8),
                                    ),
                                    maxLines: 2,
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
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Stats row
                Container(
                  color: habit.color,
                  child: Container(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 16),
                      child: Row(
                        children: [
                          _StatPill(
                            label: 'Current Streak',
                            value: '${habit.currentStreak}🔥',
                            color: habit.color,
                          ),
                          const SizedBox(width: 10),
                          _StatPill(
                            label: 'Best Streak',
                            value: '${habit.longestStreak}⭐',
                            color: AppTheme.secondary,
                          ),
                          const SizedBox(width: 10),
                          _StatPill(
                            label: 'Total Done',
                            value: '${habit.totalCompletions}✅',
                            color: AppTheme.accent,
                          ),
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
                      color: habit.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 13),
                      unselectedLabelStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                      labelColor: habit.color,
                      unselectedLabelColor: AppTheme.textSecondary,
                      indicator: BoxDecoration(
                        color: habit.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.zero,
                      onTap: (_) => setState(() {}),
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'History'),
                        Tab(text: 'Stats'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tab content
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
            icon: Icon(
                isCompletedToday
                    ? Icons.undo_rounded
                    : Icons.check_rounded,
                size: 20),
            label: Text(
                isCompletedToday ? 'Mark as Missed' : 'Complete Today!'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isCompletedToday ? AppTheme.textSecondary : habit.color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(
                  fontFamily: 'Nunito', fontWeight: FontWeight.w700),
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
  final Color color;
  const _StatPill(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    color: AppTheme.textSecondary),
                textAlign: TextAlign.center),
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
          const Text('Last 7 Days',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final day = DateTime.now().subtract(Duration(days: 6 - i));
              final isCompleted = habit.isCompletedOn(day);
              final isToday = i == 6;
              final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final weekDay = days[day.weekday - 1];
              return Column(
                children: [
                  Text(weekDay,
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppTheme.textSecondary)),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? habit.color
                          : habit.color.withOpacity(0.08),
                      border: isToday
                          ? Border.all(color: habit.color, width: 2)
                          : null,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 18)
                        : Text(
                            '${day.day}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary
                                  .withOpacity(0.6),
                            ),
                          ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('About this habit',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 8),
                Text(
                  habit.description.isEmpty
                      ? 'No description added yet.'
                      : habit.description,
                  style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.5),
                ),
                if (habit.reminders.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.alarm_rounded,
                          size: 14, color: habit.color),
                      const SizedBox(width: 4),
                      Text(
                        'Reminders: ${habit.reminders.join(', ')}',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: habit.color,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
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
    if (sorted.isEmpty) {
      return const Center(
          child: Text('No completions yet',
              style: TextStyle(
                  fontFamily: 'Nunito', color: AppTheme.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: sorted.length,
      itemBuilder: (_, i) {
        final d = sorted[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: habit.color.withOpacity(0.12),
                    shape: BoxShape.circle),
                child: Icon(Icons.check_rounded,
                    color: habit.color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${d.day}/${d.month}/${d.year}',
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary),
                    ),
                    Text(
                      i == 0 ? 'Most recent' : '${i + 1} entries ago',
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              if (i == 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: habit.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Latest',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: habit.color)),
                ),
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
    final weekData = List.generate(7, (i) {
      final day = DateTime.now().subtract(Duration(days: 6 - i));
      return habit.isCompletedOn(day) ? 1.0 : 0.0;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weekly Performance',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTheme.textSecondary)),
                const SizedBox(height: 12),
                Expanded(
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
                              const days = [
                                'M',
                                'T',
                                'W',
                                'T',
                                'F',
                                'S',
                                'S'
                              ];
                              return Text(days[v.toInt()],
                                  style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 10,
                                      color: AppTheme.textSecondary));
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: weekData
                          .asMap()
                          .entries
                          .map((e) => BarChartGroupData(
                                x: e.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: e.value,
                                    color: e.value > 0
                                        ? habit.color
                                        : habit.color.withOpacity(0.15),
                                    width: 20,
                                    borderRadius:
                                        const BorderRadius.vertical(
                                            top: Radius.circular(6)),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatItem(
                  label: 'Weekly Rate',
                  value:
                      '${(habit.completionRateThisWeek * 100).round()}%',
                  color: habit.color),
              const SizedBox(width: 10),
              _StatItem(
                label: 'All Time',
                value: '${habit.totalCompletions}',
                color: AppTheme.accent,
              ),
              const SizedBox(width: 10),
              _StatItem(
                label: 'Best Streak',
                value: '${habit.longestStreak}',
                color: AppTheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    color: AppTheme.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
