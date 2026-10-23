import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
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
        MaterialPageRoute<void>(
          builder: (context) => const VideoScreen(),
        ),
      );
    },
  );

  runApp(
    MovementBreakApp(
      appState: appState,
      navigatorKey: navigatorKey,
    ),
  );

  // Wait for Flutter to render the app.
  await WidgetsBinding.instance.endOfFrame;

  // Make sure iOS considers the application active before requesting ATT.
  await _waitForAppToBeResumed();

  // Request ATT before initializing consent/advertising services.
  await _initializeTrackingConsentAndAds();

  final permissionGranted = await notificationService.requestPermission();

  debugPrint(
    'Notification permission granted: '
    '$permissionGranted',
  );

  if (permissionGranted) {
    const notificationScheduler = NotificationScheduler();

    await notificationScheduler.scheduleNextSevenDays(
      appState: appState,
    );
  }
}

Future<void> _waitForAppToBeResumed() async {
  if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
    debugPrint('App is already resumed.');
    return;
  }

  debugPrint('Waiting for app to enter resumed state...');

  final completer = Completer<void>();
  late final AppLifecycleListener listener;

  listener = AppLifecycleListener(
    onResume: () {
      debugPrint('App entered resumed state.');

      if (!completer.isCompleted) {
        completer.complete();
      }
    },
  );

  try {
    await completer.future.timeout(const Duration(seconds: 10));
  } on TimeoutException {
    debugPrint(
      'Timed out waiting for resumed state. '
      'ATT will not be requested until a future opportunity.',
    );
  } finally {
    listener.dispose();
  }
}

Future<void> _initializeTrackingConsentAndAds() async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    try {
      final trackingStatus =
          await AppTrackingTransparency.trackingAuthorizationStatus;

      debugPrint(
        'ATT tracking authorization status before request: '
        '$trackingStatus',
      );

      if (trackingStatus == TrackingStatus.notDetermined &&
          WidgetsBinding.instance.lifecycleState ==
              AppLifecycleState.resumed) {
        final updatedStatus =
            await AppTrackingTransparency.requestTrackingAuthorization();

        debugPrint(
          'ATT tracking authorization status after request: '
          '$updatedStatus',
        );
      } else if (trackingStatus == TrackingStatus.notDetermined) {
        debugPrint(
          'ATT remains not determined, but the app is not resumed. '
          'Advertising will not be initialized.',
        );

        return;
      }
    } catch (error) {
      debugPrint(
        'ATT authorization request failed: $error',
      );

      return;
    }
  }

  final consentService = ConsentService();

  await consentService.gatherConsent();

  final canRequestAds = await consentService.canRequestAds();

  if (canRequestAds) {
    await MobileAds.instance.initialize();

    debugPrint(
      'Mobile Ads SDK initialized after ATT and consent checks.',
    );
  } else {
    debugPrint('Ads cannot be requested yet.');
  }
}