import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';

class AddHabitScreen extends StatefulWidget {
  final Habit? habit; // null = add, non-null = edit
  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  Color _selectedColor = AppTheme.primary;
  IconData _selectedIcon = Icons.star_rounded;
  HabitFrequency _frequency = HabitFrequency.daily;
  HabitCategory _category = HabitCategory.health;
  final _reminderTimes = <String>['7:00 AM'];

  final _icons = [
    Icons.local_drink_rounded,
    Icons.fitness_center_rounded,
    Icons.menu_book_rounded,
    Icons.self_improvement_rounded,
    Icons.no_food_rounded,
    Icons.edit_note_rounded,
    Icons.translate_rounded,
    Icons.bedtime_rounded,
    Icons.directions_run_rounded,
    Icons.spa_rounded,
    Icons.music_note_rounded,
    Icons.code_rounded,
  ];

  final _categoryLabels = {
    HabitCategory.health: 'Health',
    HabitCategory.fitness: 'Fitness',
    HabitCategory.mindfulness: 'Mindfulness',
    HabitCategory.learning: 'Learning',
    HabitCategory.nutrition: 'Nutrition',
    HabitCategory.productivity: 'Productivity',
    HabitCategory.social: 'Social',
    HabitCategory.creativity: 'Creativity',
  };

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController.text = widget.habit!.name;
      _descController.text = widget.habit!.description;
      _selectedColor = widget.habit!.color;
      _selectedIcon = widget.habit!.icon;
      _frequency = widget.habit!.frequency;
      _category = widget.habit!.category;
    }
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) return;
    final habit = Habit(
      id: widget.habit?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      icon: _selectedIcon,
      color: _selectedColor,
      frequency: _frequency,
      category: _category,
      completedDates:
          List.from(widget.habit?.completedDates ?? []),
      reminders: List.from(_reminderTimes),
    );
    if (widget.habit == null) {
      MockData.habits.add(habit);
    } else {
      final idx =
          MockData.habits.indexWhere((h) => h.id == habit.id);
      if (idx != -1) MockData.habits[idx] = habit;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.habit != null;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEdit ? 'Edit Habit' : 'New Habit'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save',
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and color preview
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _selectedColor.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(_selectedIcon,
                        color: Colors.white, size: 42),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap to customize',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name
            _Label('Habit Name *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style:
                  const TextStyle(fontFamily: 'Nunito', fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'e.g., Drink 8 glasses of water',
                prefixIcon: Icon(Icons.label_rounded,
                    color: AppTheme.primary, size: 20),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            _Label('Description'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              maxLines: 2,
              style:
                  const TextStyle(fontFamily: 'Nunito', fontSize: 14),
              decoration: const InputDecoration(
                  hintText: 'What motivates you to build this habit?'),
            ),
            const SizedBox(height: 20),

            // Icon picker
            _Label('Choose Icon'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _icons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _selectedColor
                          : _selectedColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: isSelected
                              ? _selectedColor
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: Icon(icon,
                        color:
                            isSelected ? Colors.white : _selectedColor,
                        size: 22),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Color picker
            _Label('Choose Color'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppTheme.habitColors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.transparent,
                          width: 3),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 8)
                            ]
                          : [],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Frequency
            _Label('Frequency'),
            const SizedBox(height: 10),
            Row(
              children:
                  HabitFrequency.values.map((f) {
                final labels = {
                  HabitFrequency.daily: 'Daily',
                  HabitFrequency.weekly: 'Weekly',
                  HabitFrequency.custom: 'Custom',
                };
                final isSelected = _frequency == f;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _frequency = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.divider,
                              width: isSelected ? 1.5 : 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          labels[f]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Category
            _Label('Category'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categoryLabels.entries.map((e) {
                final isSelected = _category == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _category = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      e.value,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Update Habit' : 'Create Habit'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
          letterSpacing: 0.3,
        ),
      );
}
