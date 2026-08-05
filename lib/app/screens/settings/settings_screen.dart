import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

import 'package:provider/provider.dart';

import '../../providers/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedDays = 'Weekdays';
  TimeOfDay startTime = const TimeOfDay(hour: 13, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 17, minute: 0);
  int reminderInterval = 45;
  bool soundEnabled = true;
  bool vibrationEnabled = true;

  Future<void> _selectStartTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (selectedTime != null) {
      setState(() {
        startTime = selectedTime;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (selectedTime != null) {
      setState(() {
        endTime = selectedTime;
      });
    }
  }

  Future<void> _selectDays() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildChoiceTile(context, title: 'Weekdays', value: 'Weekdays'),
              _buildChoiceTile(context, title: 'Every Day', value: 'Every Day'),
              _buildChoiceTile(context, title: 'Custom', value: 'Custom'),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedDays = result;
      });
    }
  }

  Future<void> _selectInterval() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildChoiceTile(context, title: 'Every 30 minutes', value: 30),
              _buildChoiceTile(context, title: 'Every 45 minutes', value: 45),
              _buildChoiceTile(context, title: 'Every 60 minutes', value: 60),
              _buildChoiceTile(context, title: 'Every 90 minutes', value: 90),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        reminderInterval = result;
      });
    }
  }

  Widget _buildChoiceTile<T>(
    BuildContext context, {
    required String title,
    required T value,
  }) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context, value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              _buildSectionTitle('SCHEDULE'),
              const SizedBox(height: 10),
              _buildSettingsCard(
                children: [
                  _buildNavigationRow(
                    icon: Icons.calendar_today_outlined,
                    title: 'Days',
                    value: selectedDays,
                    onTap: _selectDays,
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.play_circle_outline,
                    title: 'Start Time',
                    value: startTime.format(context),
                    onTap: _selectStartTime,
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.stop_circle_outlined,
                    title: 'End Time',
                    value: endTime.format(context),
                    onTap: _selectEndTime,
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.timer_outlined,
                    title: 'Interval',
                    value: 'Every $reminderInterval minutes',
                    onTap: _selectInterval,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              _buildSectionTitle('DAILY GOAL'),
              const SizedBox(height: 10),
              _buildSettingsCard(children: [_buildGoalRow(appState)]),
              const SizedBox(height: 28),

              _buildSectionTitle('NOTIFICATIONS'),
              const SizedBox(height: 10),
              _buildSettingsCard(
                children: [
                  CheckboxListTile(
                    value: soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        soundEnabled = value ?? false;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 4,
                    ),
                    secondary: const Icon(Icons.volume_up_outlined),
                    title: const Text('Sound'),
                    subtitle: const Text(
                      'Play a sound with Movement Break reminders',
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  _buildDivider(),
                  CheckboxListTile(
                    value: vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        vibrationEnabled = value ?? false;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 4,
                    ),
                    secondary: const Icon(Icons.vibration_outlined),
                    title: const Text('Vibration'),
                    subtitle: const Text(
                      'Vibrate with Movement Break reminders',
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              _buildSectionTitle('ABOUT'),
              const SizedBox(height: 10),
              _buildSettingsCard(
                children: [
                  _buildStaticRow(
                    icon: Icons.info_outline,
                    title: 'About Movement Break',
                  ),
                  _buildDivider(),
                  _buildStaticRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                  ),
                  _buildDivider(),
                  _buildStaticRow(
                    icon: Icons.description_outlined,
                    title: 'Terms of Use',
                  ),
                  _buildDivider(),
                  _buildValueRow(
                    icon: Icons.apps_outlined,
                    title: 'App Version',
                    value: '1.0.0',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryGreen,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildNavigationRow({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildGoalRow(AppState appState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.track_changes_outlined),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Movement Break Goal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text('Completed breaks count toward your goal'),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Decrease goal',
            onPressed: appState.dailyGoal > 1
                ? () async {
                    await context.read<AppState>().setDailyGoal(
                      appState.dailyGoal - 1,
                    );
                  }
                : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${appState.dailyGoal}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Increase goal',
            onPressed: () async {
              await context.read<AppState>().setDailyGoal(
                appState.dailyGoal + 1,
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticRow({required IconData icon, required String title}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title will be added before launch.')),
        );
      },
    );
  }

  Widget _buildValueRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 58);
  }
}
