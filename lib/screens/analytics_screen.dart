import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/mock_data.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';
import 'habit_detail_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedPeriod = 0; // 0=week, 1=month

  @override
  Widget build(BuildContext context) {
    final habits = MockData.habits;
    final totalCompletions =
        habits.fold(0, (s, h) => s + h.totalCompletions);
    final bestStreak =
        habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
    final avgWeeklyRate = habits.isEmpty
        ? 0.0
        : habits
                .map((h) => h.completionRateThisWeek)
                .reduce((a, b) => a + b) /
            habits.length;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: const Text(
          'Analytics',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Summary cards
          Row(
            children: [
              _SummaryCard(
                label: 'Total\nCompletions',
                value: '$totalCompletions',
                icon: Icons.check_circle_rounded,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 10),
              _SummaryCard(
                label: 'Best\nStreak',
                value: '$bestStreak 🔥',
                icon: Icons.local_fire_department_rounded,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 10),
              _SummaryCard(
                label: 'Avg Weekly\nRate',
                value: '${(avgWeeklyRate * 100).round()}%',
                icon: Icons.trending_up_rounded,
                color: AppTheme.accent,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Period toggle + weekly chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Completions Per Day',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _PeriodButton(
                        label: 'Week',
                        selected: _selectedPeriod == 0,
                        onTap: () => setState(() => _selectedPeriod = 0)),
                    _PeriodButton(
                        label: 'Month',
                        selected: _selectedPeriod == 1,
                        onTap: () => setState(() => _selectedPeriod = 1)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppTheme.cardShadow],
            ),
            child: _buildBarChart(habits),
          ),

          const SizedBox(height: 24),

          // Per-habit completion rates
          const Text(
            'Habit Performance',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...habits.map((h) => _HabitRateRow(habit: h)),

          const SizedBox(height: 24),

          // Streak leaderboard
          const Text(
            'Streak Leaderboard 🏆',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildLeaderboard(habits),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<Habit> habits) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final data = List.generate(7, (i) {
      final day = DateTime.now().subtract(Duration(days: 6 - i));
      return habits.where((h) => h.isCompletedOn(day)).length.toDouble();
    });
    final maxY = (habits.length + 1).toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppTheme.primary.withOpacity(0.9),
            getTooltipItem: (_, __, rod, ___) => BarTooltipItem(
              '${rod.toY.round()} done',
              const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 11),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Text(
                dayLabels[v.toInt()],
                style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: AppTheme.textSecondary),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 24,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt()}',
                style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    color: AppTheme.textSecondary),
              ),
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppTheme.divider, strokeWidth: 1),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: data
            .asMap()
            .entries
            .map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary,
                          AppTheme.secondary,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 22,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8)),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  List<Widget> _buildLeaderboard(List<Habit> habits) {
    final sorted = [...habits]
      ..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
    return sorted.take(5).toList().asMap().entries.map((entry) {
      final i = entry.key;
      final h = entry.value;
      final medals = ['🥇', '🥈', '🥉', '4️⃣', '5️⃣'];
      return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: h))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: i == 0
                ? AppTheme.secondary.withOpacity(0.08)
                : AppTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: i == 0 ? AppTheme.secondary.withOpacity(0.3) : AppTheme.divider,
            ),
            boxShadow: [AppTheme.cardShadow],
          ),
          child: Row(
            children: [
              Text(medals[i],
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: h.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(h.icon, color: h.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(h.name,
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppTheme.textPrimary)),
                    Text(
                        '${h.currentStreak} day streak · ${h.totalCompletions} total',
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: h.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '🔥 ${h.currentStreak}',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: h.color),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
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
                    color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PeriodButton(
      {required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: selected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _HabitRateRow extends StatelessWidget {
  final Habit habit;
  const _HabitRateRow({required this.habit});

  @override
  Widget build(BuildContext context) {
    final rate = habit.completionRateThisWeek;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
              color: habit.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(habit.icon, color: habit.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(habit.name,
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppTheme.textPrimary)),
                    Text('${(rate * 100).round()}%',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: habit.color)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: rate,
                    backgroundColor: habit.color.withOpacity(0.12),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(habit.color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
