import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' hide AppState;

import 'app/app.dart';
import 'app/providers/app_state.dart';
import 'app/screens/video/video_screen.dart';
import 'app/services/consent_service.dart';
import 'app/services/notification_scheduler.dart';
import 'app/services/notification_service.dart';
import 'app/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final consentService = ConsentService();

  await consentService.gatherConsent();

  final canRequestAds = await consentService.canRequestAds();

  if (canRequestAds) {
    await MobileAds.instance.initialize();

    debugPrint('Mobile Ads SDK initialized after consent check.');
  } else {
    debugPrint('Ads cannot be requested yet.');
  }

  final storageService = await StorageService.create();

  final appState = AppState(storageService);

  await appState.initialize();

  final navigatorKey = GlobalKey<NavigatorState>();

  final notificationService = NotificationService();

  await notificationService.initialize(
    onNotificationTapped: (payload) {
      debugPrint('Notification tapped with payload: $payload');

      if (payload != 'movement_break') {
        return;
      }

      final navigator = navigatorKey.currentState;

      if (navigator == null) {
        debugPrint('Navigator is not ready for notification navigation.');
        return;
      }

      navigator.push(
        MaterialPageRoute<void>(builder: (context) => const VideoScreen()),
      );
    },
  );

  final permissionGranted = await notificationService.requestPermission();

  debugPrint(
    'Notification permission granted: '
    '$permissionGranted',
  );

  if (permissionGranted) {
    const notificationScheduler = NotificationScheduler();

    await notificationScheduler.scheduleNextSevenDays(appState: appState);
  }

  runApp(MovementBreakApp(appState: appState, navigatorKey: navigatorKey));
}
