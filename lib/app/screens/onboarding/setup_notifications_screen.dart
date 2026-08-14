import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../../services/notification_service.dart';
import '../../theme/app_colors.dart';
import 'setup_page.dart';

class SetupNotificationsScreen extends StatefulWidget {
  const SetupNotificationsScreen({
    required this.onContinue,
    required this.onBack,
    super.key,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  State<SetupNotificationsScreen> createState() =>
      _SetupNotificationsScreenState();
}

class _SetupNotificationsScreenState extends State<SetupNotificationsScreen>
    with WidgetsBindingObserver {
  bool _isRequestingPermission = false;
  bool _permissionGranted = false;
  bool _permissionWasDenied = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final enabled = await NotificationService().areNotificationsEnabled();

    if (!mounted) {
      return;
    }

    setState(() {
      _permissionGranted = enabled;

      if (enabled) {
        _permissionWasDenied = false;
      }
    });
  }

  Future<void> _enableNotifications() async {
    if (_isRequestingPermission) {
      return;
    }

    if (_permissionWasDenied) {
      await _openNotificationSettings();
      return;
    }

    setState(() {
      _isRequestingPermission = true;
    });

    final granted = await NotificationService().requestPermission();

    if (!mounted) {
      return;
    }

    setState(() {
      _permissionGranted = granted;
      _permissionWasDenied = !granted;
      _isRequestingPermission = false;
    });

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notifications are turned off. '
            'Enable them in your device settings to receive reminders.',
          ),
        ),
      );
    }
  }

  Future<void> _openNotificationSettings() async {
    await AppSettings.openAppSettings(
      type: AppSettingsType.notification,
    );
  }

  void _continue() {
    if (!_permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enable notifications to continue.',
          ),
        ),
      );

      return;
    }

    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = _permissionGranted
        ? 'Continue'
        : _permissionWasDenied
        ? 'Open Notification Settings'
        : 'Enable Notifications';

    return SetupPage(
      step: 6,
      totalSteps: 6,
      title: 'Enable Notifications',
      subtitle: _permissionWasDenied
          ? 'Notifications are turned off. Enable them in your device '
                'settings to receive Movement Break reminders.'
          : 'Movement Break only works with notifications enabled.',
      buttonText: buttonText,
      onBack: widget.onBack,
      onContinue: _permissionGranted ? _continue : _enableNotifications,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(
                color: _permissionGranted
                    ? AppColors.primaryGreen
                    : AppColors.border,
                width: 2,
              ),
            ),
            child: Icon(
              _permissionGranted
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              size: 58,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 28),
          _buildBenefit(
            icon: Icons.schedule_outlined,
            text: 'Reminders are sent only during the schedule you choose.',
          ),
          const SizedBox(height: 16),
          _buildBenefit(
            icon: Icons.block_outlined,
            text: 'No spam or marketing notifications.',
          ),
          const SizedBox(height: 16),
          _buildBenefit(
            icon: Icons.tune_outlined,
            text: 'You can change your reminder schedule anytime in Settings.',
          ),
          if (_isRequestingPermission) ...[
            const SizedBox(height: 28),
            const CircularProgressIndicator(),
          ],
          if (_permissionGranted) ...[
            const SizedBox(height: 28),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryGreen,
                ),
                SizedBox(width: 8),
                Text(
                  'Notifications enabled',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primaryGreen,
          size: 24,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}