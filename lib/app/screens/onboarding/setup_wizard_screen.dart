import 'package:flutter/material.dart';

import 'setup_days_screen.dart';
import 'setup_goal_screen.dart';
import 'setup_interval_screen.dart';
import 'setup_notifications_screen.dart';
import 'setup_time_screen.dart';

class SetupWizardScreen extends StatefulWidget {
  const SetupWizardScreen({
    required this.initialDays,
    required this.initialStartTime,
    required this.initialEndTime,
    required this.initialInterval,
    required this.initialGoal,
    required this.onComplete,
    super.key,
  });

  final List<int> initialDays;
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;
  final int initialInterval;
  final int initialGoal;

  final Future<void> Function({
    required List<int> reminderDays,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int interval,
    required int dailyGoal,
  })
  onComplete;

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen> {
  int _currentStep = 0;

  late List<int> _reminderDays;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late int _interval;
  late int _dailyGoal;

  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();

    _reminderDays = List<int>.from(widget.initialDays);
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
    _interval = widget.initialInterval;
    _dailyGoal = widget.initialGoal;
  }

  void _nextStep() {
    if (_currentStep >= 5) {
      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    if (_currentStep <= 0) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  Future<void> _completeSetup() async {
    if (_isCompleting) {
      return;
    }

    setState(() {
      _isCompleting = true;
    });

    try {
      await widget.onComplete(
        reminderDays: _reminderDays,
        startTime: _startTime,
        endTime: _endTime,
        interval: _interval,
        dailyGoal: _dailyGoal,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return SetupDaysScreen(
          initialDays: _reminderDays,
          onBack: _previousStep,
          onContinue: (days) {
            _reminderDays = List<int>.from(days);
            _nextStep();
          },
        );

      case 1:
        return SetupTimeScreen(
          step: 2,
          title: 'When should reminders begin?',
          subtitle:
              'Choose when you would like Movement Break reminders to start.',
          initialTime: _startTime,
          onBack: _previousStep,
          onContinue: (time) {
            _startTime = time;

            if (!_endTime.isAfter(_startTime)) {
              _endTime = TimeOfDay(
                hour: (_startTime.hour + 4).clamp(0, 23),
                minute: _startTime.minute,
              );
            }

            _nextStep();
          },
        );

      case 2:
        return SetupTimeScreen(
          step: 3,
          title: 'When should reminders stop?',
          subtitle:
              'Choose when you would like Movement Break reminders to end.',
          initialTime: _endTime,
          onBack: _previousStep,
          onContinue: (time) {
            if (!time.isAfter(_startTime)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('End time must be after the start time.'),
                ),
              );
              return;
            }

            _endTime = time;
            _nextStep();
          },
        );

      case 3:
        return SetupIntervalScreen(
          initialInterval: _interval,
          onBack: _previousStep,
          onContinue: (interval) {
            _interval = interval;
            _nextStep();
          },
        );

      case 4:
        return SetupGoalScreen(
          initialGoal: _dailyGoal,
          onBack: _previousStep,
          onContinue: (goal) {
            _dailyGoal = goal;
            _nextStep();
          },
        );

      case 5:
        return SetupNotificationsScreen(
          onBack: _previousStep,
          onContinue: _completeSetup,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
