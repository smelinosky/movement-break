import 'package:flutter/foundation.dart';

import '../services/notification_scheduler.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState(this._storageService);

  final StorageService _storageService;

  static const NotificationScheduler _notificationScheduler =
      NotificationScheduler();

  int _completedBreaks = 0;
  int _dailyGoal = 4;

  List<int> _reminderDays = const [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  ];

  int _startHour = 13;
  int _startMinute = 0;
  int _endHour = 17;
  int _endMinute = 0;
  int _reminderInterval = 45;

  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _onboardingCompleted = false;
  bool _isInitialized = false;

  int get completedBreaks => _completedBreaks;
  int get dailyGoal => _dailyGoal;

  List<int> get reminderDays => List.unmodifiable(_reminderDays);

  int get startHour => _startHour;
  int get startMinute => _startMinute;
  int get endHour => _endHour;
  int get endMinute => _endMinute;
  int get reminderInterval => _reminderInterval;

  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get onboardingCompleted => _onboardingCompleted;
  bool get isInitialized => _isInitialized;

  double get dailyProgress {
    if (_dailyGoal <= 0) {
      return 0;
    }

    return (_completedBreaks / _dailyGoal).clamp(0.0, 1.0);
  }

  Future<void> initialize() async {
    final today = _dateKey(DateTime.now());
    final savedDate = await _storageService.getProgressDate();

    _dailyGoal = await _storageService.getDailyGoal();

    _reminderDays = await _storageService.getReminderDays();
    _startHour = await _storageService.getStartHour();
    _startMinute = await _storageService.getStartMinute();
    _endHour = await _storageService.getEndHour();
    _endMinute = await _storageService.getEndMinute();
    _reminderInterval = await _storageService.getReminderInterval();

    _soundEnabled = await _storageService.getSoundEnabled();

    _vibrationEnabled = await _storageService.getVibrationEnabled();

    _onboardingCompleted = await _storageService.getOnboardingCompleted();

    if (savedDate == today) {
      _completedBreaks = await _storageService.getCompletedBreaks();
    } else {
      _completedBreaks = 0;

      await _storageService.setCompletedBreaks(0);
      await _storageService.setProgressDate(today);
    }

    _isInitialized = true;

    notifyListeners();
  }

  Future<void> completeMovement() async {
    await _resetIfNewDay();

    _completedBreaks++;

    await _storageService.setCompletedBreaks(_completedBreaks);

    notifyListeners();
  }

  Future<void> completeOnboardingSetup({
    required List<int> reminderDays,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    required int reminderInterval,
    required int dailyGoal,
  }) async {
    _reminderDays = List<int>.from(reminderDays)..sort();

    _startHour = startHour;
    _startMinute = startMinute;

    _endHour = endHour;
    _endMinute = endMinute;

    _reminderInterval = reminderInterval;
    _dailyGoal = dailyGoal;

    _onboardingCompleted = true;

    await _storageService.setReminderDays(_reminderDays);

    await _storageService.setStartHour(_startHour);

    await _storageService.setStartMinute(_startMinute);

    await _storageService.setEndHour(_endHour);

    await _storageService.setEndMinute(_endMinute);

    await _storageService.setReminderInterval(_reminderInterval);

    await _storageService.setDailyGoal(_dailyGoal);

    await _storageService.setOnboardingCompleted(true);

    notifyListeners();

    await _rescheduleNotifications();
  }

  Future<void> setDailyGoal(int goal) async {
    if (goal < 1 || goal == _dailyGoal) {
      return;
    }

    _dailyGoal = goal;

    await _storageService.setDailyGoal(goal);

    notifyListeners();
  }

  Future<void> setReminderDays(List<int> days) async {
    if (days.isEmpty) {
      return;
    }

    _reminderDays = List<int>.from(days)..sort();

    await _storageService.setReminderDays(_reminderDays);

    notifyListeners();

    await _rescheduleNotifications();
  }

  Future<void> setStartTime({required int hour, required int minute}) async {
    if (hour == _startHour && minute == _startMinute) {
      return;
    }

    _startHour = hour;
    _startMinute = minute;

    await _storageService.setStartHour(hour);
    await _storageService.setStartMinute(minute);

    notifyListeners();

    await _rescheduleNotifications();
  }

  Future<void> setEndTime({required int hour, required int minute}) async {
    if (hour == _endHour && minute == _endMinute) {
      return;
    }

    _endHour = hour;
    _endMinute = minute;

    await _storageService.setEndHour(hour);
    await _storageService.setEndMinute(minute);

    notifyListeners();

    await _rescheduleNotifications();
  }

  Future<void> setReminderInterval(int minutes) async {
    if (minutes < 1 || minutes == _reminderInterval) {
      return;
    }

    _reminderInterval = minutes;

    await _storageService.setReminderInterval(minutes);

    notifyListeners();

    await _rescheduleNotifications();
  }

  Future<void> setSoundEnabled(bool value) async {
    if (value == _soundEnabled) {
      return;
    }

    _soundEnabled = value;

    await _storageService.setSoundEnabled(value);

    notifyListeners();

    await _rescheduleNotifications();
  }

  Future<void> setVibrationEnabled(bool value) async {
    if (value == _vibrationEnabled) {
      return;
    }

    _vibrationEnabled = value;

    await _storageService.setVibrationEnabled(value);

    notifyListeners();

    await _rescheduleNotifications();
  }

  Future<void> resetDailyProgress() async {
    _completedBreaks = 0;

    await _storageService.setCompletedBreaks(0);

    await _storageService.setProgressDate(_dateKey(DateTime.now()));

    notifyListeners();
  }

  Future<void> _rescheduleNotifications() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _notificationScheduler.scheduleNextSevenDays(appState: this);

      debugPrint('Movement Break notifications rescheduled.');
    } catch (error) {
      debugPrint('Movement Break rescheduling error: $error');
    }
  }

  Future<void> _resetIfNewDay() async {
    final today = _dateKey(DateTime.now());

    final savedDate = await _storageService.getProgressDate();

    if (savedDate == today) {
      return;
    }

    _completedBreaks = 0;

    await _storageService.setCompletedBreaks(0);
    await _storageService.setProgressDate(today);
  }

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
