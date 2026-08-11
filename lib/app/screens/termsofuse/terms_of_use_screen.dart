import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Use')),
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
                title: 'Agreement to These Terms',
                child: const Text(
                  'By downloading, accessing, or using Movement Break, '
                  'you agree to these Terms of Use.\n\n'
                  'If you do not agree with these terms, please do not use the app.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Purpose of Movement Break',
                child: const Text(
                  'Movement Break is a general wellness application designed to '
                  'encourage short periods of movement throughout the day and help '
                  'users build healthy movement habits.\n\n'
                  'Movement Break is not a medical device, medical service, or '
                  'substitute for professional medical advice.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Health and Safety',
                child: const Text(
                  'You are responsible for deciding whether a movement is appropriate '
                  'for you.\n\n'
                  'Move only within your abilities and stop immediately if you experience '
                  'pain, dizziness, shortness of breath, discomfort, or any other concerning '
                  'symptom.\n\n'
                  'If you have a medical condition, injury, mobility limitation, or other '
                  'health concern, consider speaking with a qualified healthcare professional '
                  'before participating in new physical activity.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'No Medical Advice',
                child: const Text(
                  'Content provided through Movement Break is for general informational '
                  'and wellness purposes only.\n\n'
                  'Nothing in the app should be interpreted as medical advice, diagnosis, '
                  'treatment, or a recommendation regarding any medical condition.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Movement Content',
                child: const Text(
                  'Movement Break provides access to short movement videos through the '
                  'official Movement Break YouTube channel.\n\n'
                  'Not every movement will be appropriate or possible for every person. '
                  'Users may skip a movement or choose a different movement at any time.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Notifications',
                child: const Text(
                  'Movement Break allows you to configure reminder notifications.\n\n'
                  'Notification delivery may depend on your device, operating system, '
                  'battery settings, connectivity, and other factors outside our control. '
                  'We do not guarantee that every reminder will be delivered at an exact time.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Advertising',
                child: const Text(
                  'Movement Break may display non-personalized advertisements through '
                  'third-party advertising services such as Google AdMob.\n\n'
                  'Third-party advertising services are governed by their own terms and '
                  'privacy practices.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Third-Party Services',
                child: const Text(
                  'Movement Break uses third-party services including YouTube and Google AdMob.\n\n'
                  'We are not responsible for the availability, content, policies, or practices '
                  'of third-party services. Your use of those services may also be subject to '
                  'their own terms and conditions.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Acceptable Use',
                child: const Text(
                  'You agree to use Movement Break only for lawful purposes and in a way '
                  'that does not interfere with, damage, misuse, or attempt to gain '
                  'unauthorized access to the app or related services.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Intellectual Property',
                child: const Text(
                  'Movement Break, including its name, branding, app design, original text, '
                  'and original movement content, is protected by applicable intellectual '
                  'property laws.\n\n'
                  'You may use the app for personal purposes, but you may not copy, reproduce, '
                  'redistribute, modify, or commercially exploit Movement Break content without '
                  'permission.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Availability and Changes',
                child: const Text(
                  'We may update, modify, suspend, or discontinue features of Movement Break '
                  'from time to time.\n\n'
                  'We may also update these Terms of Use. When we do, the Last Updated date '
                  'will be revised.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Disclaimer of Warranties',
                child: const Text(
                  'Movement Break is provided on an "as is" and "as available" basis.\n\n'
                  'To the extent permitted by law, we make no warranties regarding uninterrupted '
                  'availability, error-free operation, fitness for a particular purpose, or '
                  'specific health or wellness outcomes.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Limitation of Liability',
                child: const Text(
                  'To the extent permitted by applicable law, Movement Break and its owner '
                  'will not be liable for indirect, incidental, special, consequential, or '
                  'similar damages arising from your use of or inability to use the app.\n\n'
                  'You are responsible for using Movement Break and its movement content safely '
                  'and according to your own abilities and circumstances.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Privacy',
                child: const Text(
                  'Your use of Movement Break is also subject to the Movement Break Privacy Policy, '
                  'which explains how information is handled by the app.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Contact',
                child: const Text(
                  'If you have questions about these Terms of Use, you can contact us at:\n\n'
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
