import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'setup_page.dart';

class SetupDaysScreen extends StatefulWidget {
  const SetupDaysScreen({
    required this.initialDays,
    required this.onContinue,
    required this.onBack,
    super.key,
  });

  final List<int> initialDays;
  final ValueChanged<List<int>> onContinue;
  final VoidCallback onBack;

  @override
  State<SetupDaysScreen> createState() => _SetupDaysScreenState();
}

class _SetupDaysScreenState extends State<SetupDaysScreen> {
  late Set<int> _selectedDays;

  static const Map<int, String> _dayLabels = {
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
    DateTime.saturday: 'Sat',
    DateTime.sunday: 'Sun',
  };

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.initialDays.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SetupPage(
      step: 1,
      totalSteps: 6,
      title: 'What days should we remind you?',
      subtitle:
          'Choose the days you would like to receive Movement Break reminders.',
      buttonText: 'Continue',
      onBack: widget.onBack,
      onContinue: _continue,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 14,
        children: _dayLabels.entries.map((entry) {
          final isSelected = _selectedDays.contains(entry.key);

          return _DayButton(
            label: entry.value,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedDays.remove(entry.key);
                } else {
                  _selectedDays.add(entry.key);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  void _continue() {
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one reminder day.')),
      );
      return;
    }

    final sortedDays = _selectedDays.toList()..sort();

    widget.onContinue(sortedDays);
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 86,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.backgroundDark
                : AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
