import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show PrivacyOptionsRequirementStatus;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../services/consent_service.dart';
import '../../theme/app_colors.dart';
import '../about/about_screen.dart';
import '../privacypolicyscreen/privacy_policy_screen.dart';
import '../termsofuse/terms_of_use_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Map<int, String> _weekdayNames = {
    DateTime.monday: 'Monday',
    DateTime.tuesday: 'Tuesday',
    DateTime.wednesday: 'Wednesday',
    DateTime.thursday: 'Thursday',
    DateTime.friday: 'Friday',
    DateTime.saturday: 'Saturday',
    DateTime.sunday: 'Sunday',
  };

  static const Map<int, String> _weekdayAbbreviations = {
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
    DateTime.saturday: 'Sat',
    DateTime.sunday: 'Sun',
  };

  String _version = '';

  PrivacyOptionsRequirementStatus _privacyOptionsRequirementStatus =
      PrivacyOptionsRequirementStatus.unknown;

  @override
  void initState() {
    super.initState();

    _loadPackageInfo();
    _loadPrivacyOptionsStatus();
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (!mounted) {
      return;
    }

    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _loadPrivacyOptionsStatus() async {
    try {
      final status = await ConsentService()
          .getPrivacyOptionsRequirementStatus();

      if (!mounted) {
        return;
      }

      setState(() {
        _privacyOptionsRequirementStatus = status;
      });
    } catch (error) {
      debugPrint('Unable to load privacy options status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final startTime = TimeOfDay(
      hour: appState.startHour,
      minute: appState.startMinute,
    );

    final endTime = TimeOfDay(
      hour: appState.endHour,
      minute: appState.endMinute,
    );

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
                    value: _formatReminderDays(appState.reminderDays),
                    onTap: () {
                      _selectReminderDays(context, appState);
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.play_circle_outline,
                    title: 'Start Time',
                    value: startTime.format(context),
                    onTap: () {
                      _selectStartTime(context, appState);
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.stop_circle_outlined,
                    title: 'End Time',
                    value: endTime.format(context),
                    onTap: () {
                      _selectEndTime(context, appState);
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.timer_outlined,
                    title: 'Interval',
                    value: 'Every ${appState.reminderInterval} minutes',
                    onTap: () {
                      _selectInterval(context, appState);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              _buildSectionTitle('DAILY GOAL'),
              const SizedBox(height: 10),
              _buildSettingsCard(children: [_buildGoalRow(context, appState)]),
              const SizedBox(height: 28),

              _buildSectionTitle('NOTIFICATIONS'),
              const SizedBox(height: 10),
              _buildSettingsCard(
                children: [
                  CheckboxListTile(
                    value: appState.soundEnabled,
                    onChanged: (value) async {
                      if (value == null) {
                        return;
                      }

                      await context.read<AppState>().setSoundEnabled(value);
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
                    value: appState.vibrationEnabled,
                    onChanged: (value) async {
                      if (value == null) {
                        return;
                      }

                      await context.read<AppState>().setVibrationEnabled(value);
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
                    context,
                    icon: Icons.info_outline,
                    title: 'About Movement Break',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildStaticRow(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  if (_privacyOptionsRequirementStatus ==
                      PrivacyOptionsRequirementStatus.required) ...[
                    _buildDivider(),
                    _buildStaticRow(
                      context,
                      icon: Icons.tune_outlined,
                      title: 'Privacy & Ad Choices',
                      onTap: () {
                        _showPrivacyOptions(context);
                      },
                    ),
                  ],
                  _buildDivider(),
                  _buildStaticRow(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms of Use',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const TermsOfUseScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildValueRow(
                    icon: Icons.apps_outlined,
                    title: 'App Version',
                    value: _version.isEmpty ? '—' : _version,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPrivacyOptions(BuildContext context) async {
    try {
      await ConsentService().showPrivacyOptionsForm();
    } catch (error) {
      debugPrint('Unable to show privacy options: $error');

      if (!context.mounted) {
        return;
      }

      _showMessage(context, 'Privacy options are not available right now.');
    }
  }

  Future<void> _selectStartTime(BuildContext context, AppState appState) async {
    final currentStartTime = TimeOfDay(
      hour: appState.startHour,
      minute: appState.startMinute,
    );

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentStartTime,
    );

    if (selectedTime == null || !context.mounted) {
      return;
    }

    final selectedMinutes = _timeInMinutes(selectedTime);

    final endMinutes = _timeInMinutes(
      TimeOfDay(hour: appState.endHour, minute: appState.endMinute),
    );

    if (selectedMinutes >= endMinutes) {
      _showMessage(context, 'Start time must be before the end time.');

      return;
    }

    await context.read<AppState>().setStartTime(
      hour: selectedTime.hour,
      minute: selectedTime.minute,
    );
  }

  Future<void> _selectEndTime(BuildContext context, AppState appState) async {
    final currentEndTime = TimeOfDay(
      hour: appState.endHour,
      minute: appState.endMinute,
    );

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentEndTime,
    );

    if (selectedTime == null || !context.mounted) {
      return;
    }

    final selectedMinutes = _timeInMinutes(selectedTime);

    final startMinutes = _timeInMinutes(
      TimeOfDay(hour: appState.startHour, minute: appState.startMinute),
    );

    if (selectedMinutes <= startMinutes) {
      _showMessage(context, 'End time must be after the start time.');

      return;
    }

    await context.read<AppState>().setEndTime(
      hour: selectedTime.hour,
      minute: selectedTime.minute,
    );
  }

  Future<void> _selectInterval(BuildContext context, AppState appState) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIntervalTile(
                bottomSheetContext,
                interval: 30,
                currentInterval: appState.reminderInterval,
              ),
              _buildIntervalTile(
                bottomSheetContext,
                interval: 45,
                currentInterval: appState.reminderInterval,
              ),
              _buildIntervalTile(
                bottomSheetContext,
                interval: 60,
                currentInterval: appState.reminderInterval,
              ),
              _buildIntervalTile(
                bottomSheetContext,
                interval: 90,
                currentInterval: appState.reminderInterval,
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Custom'),
                subtitle: const Text('Enter any interval in minutes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(bottomSheetContext, -1);
                },
              ),
            ],
          ),
        );
      },
    );

    if (result == null || !context.mounted) {
      return;
    }

    if (result == -1) {
      await _selectCustomInterval(context, appState);

      return;
    }

    await context.read<AppState>().setReminderInterval(result);
  }

  Future<void> _selectCustomInterval(
    BuildContext context,
    AppState appState,
  ) async {
    final controller = TextEditingController(
      text: appState.reminderInterval.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Custom Interval'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minutes',
              hintText: 'For example, 45',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final minutes = int.tryParse(controller.text.trim());

                if (minutes == null || minutes < 1) {
                  return;
                }

                Navigator.pop(dialogContext, minutes);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null || !context.mounted) {
      return;
    }

    await context.read<AppState>().setReminderInterval(result);
  }

  Future<void> _selectReminderDays(
    BuildContext context,
    AppState appState,
  ) async {
    final selectedDays = appState.reminderDays.toSet();

    final result = await showModalBottomSheet<List<int>>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Reminder Days',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final entry in _weekdayNames.entries)
                      CheckboxListTile(
                        value: selectedDays.contains(entry.key),
                        title: Text(entry.value),
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (selected) {
                          setModalState(() {
                            if (selected == true) {
                              selectedDays.add(entry.key);
                            } else {
                              selectedDays.remove(entry.key);
                            }
                          });
                        },
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedDays.isEmpty) {
                          ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Select at least one reminder day.',
                              ),
                            ),
                          );

                          return;
                        }

                        final sortedDays = selectedDays.toList()..sort();

                        Navigator.pop(bottomSheetContext, sortedDays);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null || !context.mounted) {
      return;
    }

    await context.read<AppState>().setReminderDays(result);
  }

  Widget _buildIntervalTile(
    BuildContext context, {
    required int interval,
    required int currentInterval,
  }) {
    final selected = interval == currentInterval;

    return ListTile(
      leading: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        color: selected ? AppColors.primaryGreen : AppColors.textSecondary,
      ),
      title: Text('Every $interval minutes'),
      onTap: () {
        Navigator.pop(context, interval);
      },
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

  Widget _buildGoalRow(BuildContext context, AppState appState) {
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

  Widget _buildStaticRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap:
          onTap ??
          () {
            _showMessage(context, '$title will be added before launch.');
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

  String _formatReminderDays(List<int> days) {
    final sortedDays = List<int>.from(days)..sort();

    const weekdays = [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
    ];

    const everyDay = [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
      DateTime.sunday,
    ];

    if (_listsAreEqual(sortedDays, weekdays)) {
      return 'Weekdays';
    }

    if (_listsAreEqual(sortedDays, everyDay)) {
      return 'Every Day';
    }

    return sortedDays
        .map((day) => _weekdayAbbreviations[day])
        .whereType<String>()
        .join(', ');
  }

  bool _listsAreEqual(List<int> first, List<int> second) {
    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) {
        return false;
      }
    }

    return true;
  }

  int _timeInMinutes(TimeOfDay time) {
    return (time.hour * 60) + time.minute;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
