import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'setup_page.dart';

class SetupTimeScreen extends StatefulWidget {
  const SetupTimeScreen({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.initialTime,
    required this.onContinue,
    required this.onBack,
    super.key,
  });

  final int step;
  final String title;
  final String subtitle;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onContinue;
  final VoidCallback onBack;

  @override
  State<SetupTimeScreen> createState() => _SetupTimeScreenState();
}

class _SetupTimeScreenState extends State<SetupTimeScreen> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return SetupPage(
      step: widget.step,
      totalSteps: 6,
      title: widget.title,
      subtitle: widget.subtitle,
      buttonText: 'Continue',
      onBack: widget.onBack,
      onContinue: () {
        widget.onContinue(_selectedTime);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 64,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 24),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _pickTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryGreen,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap the time to change it',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _selectedTime = result;
    });
  }
}
