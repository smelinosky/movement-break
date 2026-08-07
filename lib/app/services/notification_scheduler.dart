import 'package:flutter/foundation.dart';

import '../providers/app_state.dart';
import 'notification_service.dart';

class NotificationScheduler {
  const NotificationScheduler();

  static const int _scheduledNotificationIdStart = 1000;
  static const int _daysToSchedule = 7;

  List<DateTime> buildSchedule({required AppState appState, DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    final reminders = <DateTime>[];

    for (var dayOffset = 0; dayOffset < _daysToSchedule; dayOffset++) {
      final date = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day + dayOffset,
      );

      if (!appState.reminderDays.contains(date.weekday)) {
        continue;
      }

      final start = DateTime(
        date.year,
        date.month,
        date.day,
        appState.startHour,
        appState.startMinute,
      );

      final end = DateTime(
        date.year,
        date.month,
        date.day,
        appState.endHour,
        appState.endMinute,
      );

      if (!end.isAfter(start)) {
        continue;
      }

      var reminderTime = start;

      while (!reminderTime.isAfter(end)) {
        if (reminderTime.isAfter(currentTime)) {
          reminders.add(reminderTime);
        }

        reminderTime = reminderTime.add(
          Duration(minutes: appState.reminderInterval),
        );
      }
    }

    return reminders;
  }

  Future<void> scheduleNextSevenDays({
    required AppState appState,
    DateTime? now,
  }) async {
    final notificationService = NotificationService();

    await notificationService.cancelAll();

    final reminders = buildSchedule(appState: appState, now: now);

    if (reminders.isEmpty) {
      debugPrint(
        'Movement Break scheduler: no reminders in the next seven days.',
      );
      return;
    }

    debugPrint(
      'Movement Break scheduler: scheduling '
      '${reminders.length} reminders for the next seven days.',
    );

    for (var index = 0; index < reminders.length; index++) {
      final reminder = reminders[index];

      await notificationService.scheduleMovementNotification(
        id: _scheduledNotificationIdStart + index,
        scheduledTime: reminder,
        soundEnabled: appState.soundEnabled,
        vibrationEnabled: appState.vibrationEnabled,
      );

      debugPrint(
        'Scheduled reminder ${index + 1}: '
        '${_formatDateTime(reminder)}',
      );
    }

    final pending = await notificationService.getPendingNotifications();

    debugPrint(
      'Movement Break pending notification count: '
      '${pending.length}',
    );
  }

  void debugPrintSchedule({required AppState appState, DateTime? now}) {
    final reminders = buildSchedule(appState: appState, now: now);

    if (reminders.isEmpty) {
      debugPrint(
        'Movement Break scheduler: no reminders in the next seven days.',
      );
      return;
    }

    debugPrint(
      'Movement Break scheduler: '
      '${reminders.length} reminders in the next seven days.',
    );

    for (final reminder in reminders) {
      debugPrint('Reminder: ${_formatDateTime(reminder)}');
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final weekday = switch (dateTime.weekday) {
      DateTime.monday => 'Mon',
      DateTime.tuesday => 'Tue',
      DateTime.wednesday => 'Wed',
      DateTime.thursday => 'Thu',
      DateTime.friday => 'Fri',
      DateTime.saturday => 'Sat',
      DateTime.sunday => 'Sun',
      _ => '',
    };

    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');

    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour = switch (hour) {
      0 => 12,
      > 12 => hour - 12,
      _ => hour,
    };

    return '$weekday $month/$day at '
        '$displayHour:$minute $period';
  }
}
