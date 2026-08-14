import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';
  String _buildNumber = '';

  static final Uri _websiteUrl = Uri.parse('https://movementbreak.app');

  static final Uri _youtubeUrl = Uri.parse(
    'https://www.youtube.com/channel/UCzaGClKFH5W5ny_APmvCMFQ',
  );

  static final Uri _linkedInUrl = Uri.parse(
    'https://www.linkedin.com/company/movementbreak/',
  );

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (!mounted) {
      return;
    }

    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  Future<void> _openLink(BuildContext context, Uri url) async {
    final launched = await launchUrl(url, mode: LaunchMode.externalApplication);

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open this link right now.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About Movement Break')),
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
              _buildBrandHeader(theme),
              const SizedBox(height: 28),

              _buildSectionCard(
                title: 'Our Mission',
                child: const Text(
                  'To help people build healthy movement habits without breaking a sweat.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Our Vision',
                child: const Text(
                  'A world where movement breaks are as common as coffee breaks.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Why Movement Break?',
                child: const Text(
                  'Movement Break was created to make movement simple.\n\n'
                  'Instead of asking you to commit to long workouts, Movement Break helps you build healthier habits through quick movement breaks that fit naturally into your day.\n\n'
                  'Every movement counts.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Our Philosophy',
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PhilosophyItem(
                      text: 'Consistency is more important than intensity.',
                    ),
                    _PhilosophyItem(
                      text: 'Small actions lead to lasting habits.',
                    ),
                    _PhilosophyItem(
                      text: 'Progress matters more than perfection.',
                    ),
                    _PhilosophyItem(
                      text: 'Healthy movement should feel approachable.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Privacy',
                child: const Text(
                  'Movement Break does not collect personal health information.\n\n'
                  'Your reminder schedule and daily progress are stored locally on your device.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Credits',
                child: const Text(
                  'Movement videos are provided through the official Movement Break YouTube channel.',
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Connect',
                child: Column(
                  children: [
                    _ConnectRow(
                      icon: Icons.language_outlined,
                      label: 'movementbreak.app',
                      onTap: () {
                        _openLink(context, _websiteUrl);
                      },
                    ),
                    const SizedBox(height: 14),
                    _ConnectRow(
                      icon: Icons.play_circle_outline,
                      label: 'YouTube',
                      onTap: () {
                        _openLink(context, _youtubeUrl);
                      },
                    ),
                    const SizedBox(height: 14),
                    _ConnectRow(
                      icon: Icons.business_center_outlined,
                      label: 'LinkedIn',
                      onTap: () {
                        _openLink(context, _linkedInUrl);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Version',
                child: Text(
                  _version.isEmpty
                      ? 'Loading version information...'
                      : 'Version $_version\n'
                            'Build $_buildNumber\n\n'
                            '© 2026 Movement Break',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),

              Text(
                'Healthy habits are built one movement at a time.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.primaryGreen),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/branding/movement_break_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Movement Break',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Exercise snacks to build healthy movement habits.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
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

class _PhilosophyItem extends StatelessWidget {
  const _PhilosophyItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 7, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ConnectRow extends StatelessWidget {
  const _ConnectRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
