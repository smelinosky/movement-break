import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../services/notification_scheduler.dart';
import '../../theme/app_colors.dart';
import '../../widgets/lets_move_button.dart';
import '../settings/settings_screen.dart';
import '../video/video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const NotificationScheduler _notificationScheduler =
      NotificationScheduler();

  Timer? _clockTimer;

  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshForCurrentTime();
    });

    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _refreshForCurrentTime();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshForCurrentTime();
    }
  }

  Future<void> _refreshForCurrentTime() async {
    if (!mounted) {
      return;
    }

    await context.read<AppState>().checkForNewDay();

    if (!mounted) {
      return;
    }

    setState(() {
      _now = DateTime.now();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _clockTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final progress = appState.dailyProgress;

    final reminders = _notificationScheduler.buildSchedule(
      appState: appState,
      now: _now,
    );

    final nextReminder = reminders.isEmpty ? null : reminders.first;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.backgroundDark],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 42),
                _buildProgressSection(
                  context,
                  completedBreaks: appState.completedBreaks,
                  dailyGoal: appState.dailyGoal,
                  progress: progress,
                ),
                const SizedBox(height: 42),
                _buildMoveButton(context),
                const SizedBox(height: 44),
                _buildReminderCard(context, nextReminder: nextReminder),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryGreen),
          ),
          child: Image.asset(
            'assets/branding/movement_break_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Movement Break', style: theme.textTheme.titleLarge),
        ),
        IconButton(
          tooltip: 'Settings',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
    BuildContext context, {
    required int completedBreaks,
    required int dailyGoal,
    required double progress,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.inactive,
                  color: AppColors.primaryGreen,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$completedBreaks / $dailyGoal',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'BREAKS',
                    style: theme.textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Great job! Keep it going.', style: theme.textTheme.titleMedium),
      ],
    );
  }

  Widget _buildMoveButton(BuildContext context) {
    return LetsMoveButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => const VideoScreen()),
        );
      },
    );
  }

  Widget _buildReminderCard(
    BuildContext context, {
    required DateTime? nextReminder,
  }) {
    final theme = Theme.of(context);

    final hasReminder = nextReminder != null;

    final timeText = hasReminder
        ? TimeOfDay.fromDateTime(nextReminder).format(context)
        : 'No upcoming reminders';

    final detailText = hasReminder
        ? '${_dayLabel(nextReminder)} • '
              '${_relativeTime(nextReminder)}'
        : 'Check your reminder schedule in Settings';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.backgroundDark,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next Movement Break', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 5),
                Text(timeText, style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(detailText, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _dayLabel(DateTime reminder) {
    final today = DateTime(_now.year, _now.month, _now.day);

    final reminderDay = DateTime(reminder.year, reminder.month, reminder.day);

    final difference = reminderDay.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Tomorrow';
    }

    return switch (reminder.weekday) {
      DateTime.monday => 'Monday',
      DateTime.tuesday => 'Tuesday',
      DateTime.wednesday => 'Wednesday',
      DateTime.thursday => 'Thursday',
      DateTime.friday => 'Friday',
      DateTime.saturday => 'Saturday',
      DateTime.sunday => 'Sunday',
      _ => '',
    };
  }

  String _relativeTime(DateTime reminder) {
    final difference = reminder.difference(_now);

    if (difference.inMinutes < 1) {
      return 'in less than a minute';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;

      return minutes == 1 ? 'in 1 minute' : 'in $minutes minutes';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;

      final remainingMinutes = difference.inMinutes.remainder(60);

      if (remainingMinutes == 0) {
        return hours == 1 ? 'in 1 hour' : 'in $hours hours';
      }

      return 'in ${hours}h '
          '${remainingMinutes}m';
    }

    final days = difference.inDays;

    return days == 1 ? 'in 1 day' : 'in $days days';
  }
}
