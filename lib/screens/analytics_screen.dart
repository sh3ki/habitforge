import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/habit_data.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';
import 'habit_detail_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final habits = HabitData.habits;
    final totalCompletions = habits.fold(0, (s, h) => s + h.totalCompletions);
    final bestStreak = habits.isEmpty ? 0 : habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
    final avgWeeklyRate = habits.isEmpty ? 0.0 : habits.map((h) => h.completionRateThisWeek).reduce((a, b) => a + b) / habits.length;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: const Text('Analytics', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: AppTheme.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Summary cards
          Row(
            children: [
              _SummaryCard(label: 'Total\nDone', value: '$totalCompletions', icon: Icons.check_circle_rounded, color: AppTheme.primary),
              const SizedBox(width: 10),
              _SummaryCard(label: 'Best\nStreak', value: '$bestStreak', icon: Icons.local_fire_department_rounded, color: AppTheme.secondary),
              const SizedBox(width: 10),
              _SummaryCard(label: 'Avg Weekly\nRate', value: '${(avgWeeklyRate * 100).round()}%', icon: Icons.trending_up_rounded, color: AppTheme.accent),
            ],
          ),
          const SizedBox(height: 24),

          // Weekly chart
          const Text('Completions Per Day',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
          const SizedBox(height: 14),
          Container(
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [AppTheme.cardShadow],
            ),
            child: _buildBarChart(habits),
          ),
          const SizedBox(height: 24),

          // Per-habit rates
          const Text('Habit Performance',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          ...habits.map((h) => _HabitRateRow(habit: h)),
          const SizedBox(height: 24),

          // Streak leaderboard
          const Text('Streak Leaderboard',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
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
            getTooltipColor: (_) => AppTheme.primary,
            getTooltipItem: (_, __, rod, ___) => BarTooltipItem(
              '${rod.toY.round()} done',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Text(dayLabels[v.toInt()],
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 24,
              getTitlesWidget: (v, _) => Text('${v.toInt()}',
                style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (_) => const FlLine(color: AppTheme.divider, strokeWidth: 1),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((e) => BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: e.value,
              color: AppTheme.secondary,
              width: 22,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ],
        )).toList(),
      ),
    );
  }

  List<Widget> _buildLeaderboard(List<Habit> habits) {
    final sorted = [...habits]..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
    final medals = [Icons.emoji_events_rounded, Icons.workspace_premium_rounded, Icons.military_tech_rounded];
    final medalColors = [const Color(0xFFD4A373), AppTheme.textSecondary, const Color(0xFF9B5DE5)];

    return sorted.take(5).toList().asMap().entries.map((entry) {
      final i = entry.key;
      final h = entry.value;
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: h))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: i == 0 ? AppTheme.secondary.withOpacity(0.06) : AppTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: i == 0 ? AppTheme.secondary.withOpacity(0.2) : AppTheme.divider),
            boxShadow: [AppTheme.cardShadow],
          ),
          child: Row(
            children: [
              if (i < 3)
                Icon(medals[i], color: medalColors[i], size: 22)
              else
                SizedBox(width: 22, child: Center(
                  child: Text('${i + 1}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
                )),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: h.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(h.icon, color: h.color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(h.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary)),
                    Text('${h.currentStreak} day streak  |  ${h.totalCompletions} total',
                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: h.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 14, color: h.color),
                    const SizedBox(width: 2),
                    Text('${h.currentStreak}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: h.color)),
                  ],
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
  const _SummaryCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: habit.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(habit.icon, color: habit.color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Container(
                  height: 5,
                  decoration: BoxDecoration(color: AppTheme.divider, borderRadius: BorderRadius.circular(3)),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: rate,
                    child: Container(
                      decoration: BoxDecoration(color: habit.color, borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text('${(rate * 100).round()}%', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: habit.color)),
        ],
      ),
    );
  }
}
