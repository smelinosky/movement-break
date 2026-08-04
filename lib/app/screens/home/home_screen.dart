import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../settings/settings_screen.dart';
import '../video/video_screen.dart';
import '../../widgets/lets_move_button.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final progress = appState.dailyProgress;
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
                _buildReminderCard(context),
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
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryGreen),
          ),
          child: const Icon(Icons.radar, color: AppColors.primaryGreen),
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

  Widget _buildReminderCard(BuildContext context) {
    final theme = Theme.of(context);

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
                Text('Next Reminder', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 5),
                Text('2:15 PM', style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('in 28 minutes', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
