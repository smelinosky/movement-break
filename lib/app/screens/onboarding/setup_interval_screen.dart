import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'setup_page.dart';

class SetupIntervalScreen extends StatefulWidget {
  const SetupIntervalScreen({
    required this.initialInterval,
    required this.onContinue,
    required this.onBack,
    super.key,
  });

  final int initialInterval;
  final ValueChanged<int> onContinue;
  final VoidCallback onBack;

  @override
  State<SetupIntervalScreen> createState() => _SetupIntervalScreenState();
}

class _SetupIntervalScreenState extends State<SetupIntervalScreen> {
  late int _selectedInterval;

  static const List<int> _presetIntervals = [30, 45, 60, 90];

  @override
  void initState() {
    super.initState();
    _selectedInterval = widget.initialInterval;
  }

  @override
  Widget build(BuildContext context) {
    return SetupPage(
      step: 4,
      totalSteps: 6,
      title: 'How often would you like to move?',
      subtitle:
          'Choose how much time you would like between Movement Break reminders.',
      buttonText: 'Continue',
      onBack: widget.onBack,
      onContinue: () {
        widget.onContinue(_selectedInterval);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 14,
            children: _presetIntervals.map((interval) {
              return _IntervalButton(
                interval: interval,
                isSelected: _selectedInterval == interval,
                onTap: () {
                  setState(() {
                    _selectedInterval = interval;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _selectCustomInterval,
            icon: const Icon(Icons.edit_outlined),
            label: Text(
              _presetIntervals.contains(_selectedInterval)
                  ? 'Custom'
                  : 'Custom: $_selectedInterval minutes',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectCustomInterval() async {
    final controller = TextEditingController(
      text: _selectedInterval.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Custom Interval'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minutes',
              hintText: 'For example, 45',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final minutes = int.tryParse(controller.text.trim());

                if (minutes == null || minutes < 1) {
                  return;
                }

                Navigator.pop(dialogContext, minutes);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _selectedInterval = result;
    });
  }
}

class _IntervalButton extends StatelessWidget {
  const _IntervalButton({
    required this.interval,
    required this.isSelected,
    required this.onTap,
  });

  final int interval;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 128,
        height: 78,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$interval',
              style: TextStyle(
                color: isSelected
                    ? AppColors.backgroundDark
                    : AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'minutes',
              style: TextStyle(
                color: isSelected
                    ? AppColors.backgroundDark
                    : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
