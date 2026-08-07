import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService(this._preferences);

  final SharedPreferences _preferences;

  // Daily progress.
  static const String _completedBreaksKey = 'completed_breaks';
  static const String _dailyGoalKey = 'daily_goal';
  static const String _progressDateKey = 'progress_date';

  // Reminder schedule.
  static const String _reminderDaysKey = 'reminder_days';
  static const String _startHourKey = 'start_hour';
  static const String _startMinuteKey = 'start_minute';
  static const String _endHourKey = 'end_hour';
  static const String _endMinuteKey = 'end_minute';
  static const String _reminderIntervalKey = 'reminder_interval';

  // Notification preferences.
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';

  // Onboarding.
  static const String _onboardingCompletedKey = 'onboarding_completed';

  static Future<StorageService> create() async {
    final preferences = await SharedPreferences.getInstance();
    return StorageService(preferences);
  }

  // Daily progress

  Future<int> getCompletedBreaks() async {
    return _preferences.getInt(_completedBreaksKey) ?? 0;
  }

  Future<void> setCompletedBreaks(int value) async {
    await _preferences.setInt(_completedBreaksKey, value);
  }

  Future<int> getDailyGoal() async {
    return _preferences.getInt(_dailyGoalKey) ?? 4;
  }

  Future<void> setDailyGoal(int value) async {
    await _preferences.setInt(_dailyGoalKey, value);
  }

  Future<String?> getProgressDate() async {
    return _preferences.getString(_progressDateKey);
  }

  Future<void> setProgressDate(String value) async {
    await _preferences.setString(_progressDateKey, value);
  }

  // Reminder schedule

  Future<List<int>> getReminderDays() async {
    final storedDays = _preferences.getStringList(_reminderDaysKey);

    if (storedDays == null || storedDays.isEmpty) {
      return const [
        DateTime.monday,
        DateTime.tuesday,
        DateTime.wednesday,
        DateTime.thursday,
        DateTime.friday,
      ];
    }

    return storedDays.map(int.tryParse).whereType<int>().toList();
  }

  Future<void> setReminderDays(List<int> days) async {
    await _preferences.setStringList(
      _reminderDaysKey,
      days.map((day) => day.toString()).toList(),
    );
  }

  Future<int> getStartHour() async {
    return _preferences.getInt(_startHourKey) ?? 13;
  }

  Future<void> setStartHour(int value) async {
    await _preferences.setInt(_startHourKey, value);
  }

  Future<int> getStartMinute() async {
    return _preferences.getInt(_startMinuteKey) ?? 0;
  }

  Future<void> setStartMinute(int value) async {
    await _preferences.setInt(_startMinuteKey, value);
  }

  Future<int> getEndHour() async {
    return _preferences.getInt(_endHourKey) ?? 17;
  }

  Future<void> setEndHour(int value) async {
    await _preferences.setInt(_endHourKey, value);
  }

  Future<int> getEndMinute() async {
    return _preferences.getInt(_endMinuteKey) ?? 0;
  }

  Future<void> setEndMinute(int value) async {
    await _preferences.setInt(_endMinuteKey, value);
  }

  Future<int> getReminderInterval() async {
    return _preferences.getInt(_reminderIntervalKey) ?? 45;
  }

  Future<void> setReminderInterval(int value) async {
    await _preferences.setInt(_reminderIntervalKey, value);
  }

  // Notification preferences

  Future<bool> getSoundEnabled() async {
    return _preferences.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool value) async {
    await _preferences.setBool(_soundEnabledKey, value);
  }

  Future<bool> getVibrationEnabled() async {
    return _preferences.getBool(_vibrationEnabledKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool value) async {
    await _preferences.setBool(_vibrationEnabledKey, value);
  }

  // Onboarding

  Future<bool> getOnboardingCompleted() async {
    return _preferences.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _preferences.setBool(_onboardingCompletedKey, value);
  }
}
