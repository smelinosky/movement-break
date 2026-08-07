import 'package:flutter/foundation.dart';

import '../providers/app_state.dart';

class NotificationScheduler {
  const NotificationScheduler();

  List<DateTime> buildTodaySchedule({
    required AppState appState,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    if (!appState.reminderDays.contains(currentTime.weekday)) {
      return const [];
    }

    final start = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      appState.startHour,
      appState.startMinute,
    );

    final end = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      appState.endHour,
      appState.endMinute,
    );

    if (!end.isAfter(start)) {
      return const [];
    }

    final reminders = <DateTime>[];
    var reminderTime = start;

    while (!reminderTime.isAfter(end)) {
      if (reminderTime.isAfter(currentTime)) {
        reminders.add(reminderTime);
      }

      reminderTime = reminderTime.add(
        Duration(minutes: appState.reminderInterval),
      );
    }

    return reminders;
  }

  void debugPrintTodaySchedule({required AppState appState, DateTime? now}) {
    final reminders = buildTodaySchedule(appState: appState, now: now);

    if (reminders.isEmpty) {
      debugPrint('Movement Break scheduler: no remaining reminders today.');
      return;
    }

    debugPrint(
      'Movement Break scheduler: ${reminders.length} reminders today.',
    );

    for (final reminder in reminders) {
      debugPrint('Reminder: ${_formatTime(reminder)}');
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour = switch (hour) {
      0 => 12,
      > 12 => hour - 12,
      _ => hour,
    };

    return '$displayHour:$minute $period';
  }
}
