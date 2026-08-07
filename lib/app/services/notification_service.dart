import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  static const String movementChannelId = 'movement_break_reminders';

  static const String movementChannelName = 'Movement Break Reminders';

  static const String movementChannelDescription =
      'Reminders to take a short Movement Break.';

  static const int testNotificationId = 1;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _timeZoneInitialized = false;

  Future<void> initialize({
    void Function(String? payload)? onNotificationTapped,
  }) async {
    if (_isInitialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        onNotificationTapped?.call(response.payload);
      },
    );

    await _createAndroidNotificationChannel();
    await _initializeTimeZone();

    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();

      return granted ?? false;
    }

    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return granted ?? false;
    }

    return true;
  }

  Future<bool> areNotificationsEnabled() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      return await androidPlugin.areNotificationsEnabled() ?? false;
    }

    return true;
  }

  Future<void> showTestNotification({
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) async {
    _ensureInitialized();

    final notificationDetails = _buildNotificationDetails(
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
    );

    await _notifications.show(
      id: testNotificationId,
      title: 'Movement Break',
      body: 'Time to move! Tap to start your next Movement Break.',
      notificationDetails: notificationDetails,
      payload: 'movement_break',
    );
  }

  Future<void> scheduleMovementNotification({
    required int id,
    required DateTime scheduledTime,
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) async {
    _ensureInitialized();

    if (!_timeZoneInitialized) {
      await _initializeTimeZone();
    }

    final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    if (!scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      debugPrint('Skipping past notification time: $scheduledTime');
      return;
    }

    final notificationDetails = _buildNotificationDetails(
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
    );

    await _notifications.zonedSchedule(
      id: id,
      title: 'Movement Break',
      body: 'Time to move! Tap to start your next Movement Break.',
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'movement_break',
    );

    debugPrint(
      'Scheduled Movement Break notification $id '
      'for $scheduledDate',
    );
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notifications.pendingNotificationRequests();
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  NotificationDetails _buildNotificationDetails({
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        movementChannelId,
        movementChannelName,
        channelDescription: movementChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: soundEnabled,
        enableVibration: vibrationEnabled,
        ticker: 'Movement Break reminder',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: soundEnabled,
      ),
    );
  }

  Future<void> _initializeTimeZone() async {
    if (_timeZoneInitialized) {
      return;
    }

    tz.initializeTimeZones();

    try {
      final timeZone = await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(tz.getLocation(timeZone.identifier));

      debugPrint('Movement Break timezone: ${timeZone.identifier}');
    } catch (error) {
      debugPrint('Could not determine local timezone: $error');
    }

    _timeZoneInitialized = true;
  }

  Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      movementChannelId,
      movementChannelName,
      description: movementChannelDescription,
      importance: Importance.high,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      debugPrint('Android notification implementation is unavailable.');
      return;
    }

    await androidPlugin.createNotificationChannel(channel);
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('NotificationService must be initialized before use.');
    }
  }
}
