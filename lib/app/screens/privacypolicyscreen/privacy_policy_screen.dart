import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
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
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              Text(
                'Last Updated: August 10, 2026',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionCard(
                title: 'Privacy at a Glance',
                child: const Text(
                  'Movement Break was designed with privacy in mind.\n\n'
                  'We do not require an account, collect personal health information, or sell your personal information. '
                  'Your reminder schedule and daily progress are stored only on your device.\n\n'
                  'We believe your movement habits belong to you. Our goal is to help you build healthier routines—not to collect your personal information.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Information Stored on Your Device',
                child: const Text(
                  'Movement Break stores certain settings locally on your device, including:\n\n'
                  '• Reminder schedule\n'
                  '• Selected reminder days\n'
                  '• Reminder interval\n'
                  '• Daily movement goal\n'
                  '• Completed movement breaks\n'
                  '• Notification preferences\n'
                  '• Onboarding completion status\n\n'
                  'This information remains on your device and is not transmitted to Movement Break.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Information We Do Not Collect',
                child: const Text(
                  'Movement Break does not collect:\n\n'
                  '• Your name\n'
                  '• Email address\n'
                  '• Phone number\n'
                  '• Home address\n'
                  '• GPS location\n'
                  '• Contacts\n'
                  '• Health records\n'
                  '• Heart rate\n'
                  '• Step counts\n'
                  '• Fitness tracker information\n'
                  '• Camera or microphone data\n'
                  '• User account information',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Advertising',
                child: const Text(
                  'Movement Break displays non-personalized banner advertisements using Google AdMob.\n\n'
                  'Non-personalized advertisements are not based on your personal interests or behavior.\n\n'
                  'Google may collect limited technical information necessary to provide advertising services under its own privacy policies.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Video Content',
                child: const Text(
                  'Movement Break streams movement videos from the official Movement Break YouTube channel.\n\n'
                  'Watching these videos may involve services provided by YouTube. Your use of YouTube is subject to Google and YouTube privacy policies and terms.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Notifications',
                child: const Text(
                  'Movement Break requests notification permission so it can deliver the reminders you schedule.\n\n'
                  'Notifications are used for the core reminder functionality of the app.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Data Storage',
                child: const Text(
                  'Your reminder settings and daily progress are stored locally on your device.\n\n'
                  'If you uninstall Movement Break, your operating system may remove this locally stored information.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Data Sharing',
                child: const Text(
                  'Movement Break does not sell, rent, or share your personal information.\n\n'
                  'The app uses third-party services from Google AdMob and YouTube, which operate under their own privacy policies.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Children’s Privacy',
                child: const Text(
                  'Movement Break is not directed toward children under the age required by applicable law without parental supervision.\n\n'
                  'We do not knowingly collect personal information from children.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Changes to This Privacy Policy',
                child: const Text(
                  'This Privacy Policy may be updated from time to time.\n\n'
                  'When changes are made, the Last Updated date will be revised.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Contact',
                child: const Text(
                  'If you have questions, feedback, or concerns about this Privacy Policy or Movement Break, you can contact us at:\n\n'
                  'support@movementbreak.app\n\n'
                  'movementbreak.app',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          DefaultTextStyle(
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.5,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
