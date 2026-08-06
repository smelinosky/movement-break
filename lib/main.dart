import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'app/providers/app_state.dart';
import 'app/services/notification_service.dart';
import 'app/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final storageService = await StorageService.create();
  final appState = AppState(storageService);
  await appState.initialize();

  final notificationService = NotificationService();

  await notificationService.initialize(
    onNotificationTapped: (payload) {
      debugPrint('Notification tapped with payload: $payload');
    },
  );

  final permissionGranted = await notificationService.requestPermission();

  debugPrint('Notification permission granted: $permissionGranted');

  runApp(MovementBreakApp(appState: appState));
}
