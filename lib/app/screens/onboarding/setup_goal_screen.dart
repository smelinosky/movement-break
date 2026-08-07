import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'setup_page.dart';

class SetupGoalScreen extends StatefulWidget {
  const SetupGoalScreen({
    required this.initialGoal,
    required this.onContinue,
    required this.onBack,
    super.key,
  });

  final int initialGoal;
  final ValueChanged<int> onContinue;
  final VoidCallback onBack;

  @override
  State<SetupGoalScreen> createState() => _SetupGoalScreenState();
}

class _SetupGoalScreenState extends State<SetupGoalScreen> {
  late int _goal;

  @override
  void initState() {
    super.initState();
    _goal = widget.initialGoal;
  }

  @override
  Widget build(BuildContext context) {
    return SetupPage(
      step: 5,
      totalSteps: 6,
      title: 'What’s your daily goal?',
      subtitle:
          'Choose how many Movement Breaks you would like to complete each day.',
      buttonText: 'Continue',
      onBack: widget.onBack,
      onContinue: () {
        widget.onContinue(_goal);
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Decrease goal',
              onPressed: _goal > 1
                  ? () {
                      setState(() {
                        _goal--;
                      });
                    }
                  : null,
              iconSize: 40,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_goal',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 54,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'breaks per day',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Increase goal',
              onPressed: () {
                setState(() {
                  _goal++;
                });
              },
              iconSize: 40,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
