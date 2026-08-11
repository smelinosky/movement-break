import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/banner_ad_widget.dart';
import '../home/home_screen.dart';

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final completedBreaks = appState.completedBreaks;
    final dailyGoal = appState.dailyGoal;
    final safeGoal = dailyGoal <= 0 ? 1 : dailyGoal;
    final progress = (completedBreaks / safeGoal).clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.backgroundDark],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 42, 24, 28),
            child: Column(
              children: [
                _buildCheckMark(),
                const SizedBox(height: 30),
                Text(
                  'Nice Work.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'You completed a Movement Break.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Each break helps build a healthier movement habit.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 36),
                _buildProgressCard(
                  context,
                  completedBreaks: completedBreaks,
                  dailyGoal: dailyGoal,
                  progress: progress,
                ),
                const SizedBox(height: 24),

                const BannerAdWidget(),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckMark() {
    return Container(
      width: 118,
      height: 118,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryGreen,
        border: Border.all(color: AppColors.textPrimary, width: 4),
        boxShadow: const [
          BoxShadow(color: Color(0x8025E987), blurRadius: 38, spreadRadius: 7),
        ],
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 72,
        color: AppColors.backgroundDark,
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context, {
    required int completedBreaks,
    required int dailyGoal,
    required double progress,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'TODAY’S PROGRESS',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '$completedBreaks / $dailyGoal',
            style: theme.textTheme.displayLarge?.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppColors.inactive,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _progressMessage(
              completedBreaks: completedBreaks,
              dailyGoal: dailyGoal,
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _progressMessage({
    required int completedBreaks,
    required int dailyGoal,
  }) {
    if (completedBreaks >= dailyGoal) {
      return 'You reached your movement goal today.';
    }

    if (completedBreaks >= dailyGoal / 2) {
      return 'You’re making great progress. Keep moving.';
    }

    return 'A little movement can make a meaningful difference.';
  }
}
