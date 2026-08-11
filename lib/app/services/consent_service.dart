import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ConsentService {
  ConsentService._internal();

  static final ConsentService _instance = ConsentService._internal();

  factory ConsentService() => _instance;

  Future<void> gatherConsent() async {
    final completer = Completer<void>();

    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () {
        debugPrint('UMP consent information updated.');

        ConsentForm.loadAndShowConsentFormIfRequired((formError) {
          if (formError != null) {
            debugPrint(
              'Consent form error: '
              '${formError.errorCode} '
              '${formError.message}',
            );
          } else {
            debugPrint('UMP consent form flow completed.');
          }

          _completeSafely(completer);
        });
      },
      (formError) {
        debugPrint(
          'Consent info update failed: '
          '${formError.errorCode} '
          '${formError.message}',
        );

        _completeSafely(completer);
      },
    );

    try {
      await completer.future.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      debugPrint(
        'UMP consent check timed out. '
        'Continuing app startup without requesting ads.',
      );
    }
  }

  void _completeSafely(Completer<void> completer) {
    if (!completer.isCompleted) {
      completer.complete();
    }
  }

  Future<bool> canRequestAds() {
    return ConsentInformation.instance.canRequestAds();
  }

  Future<PrivacyOptionsRequirementStatus> getPrivacyOptionsRequirementStatus() {
    return ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
  }

  Future<void> showPrivacyOptionsForm() async {
    await ConsentForm.showPrivacyOptionsForm((formError) {
      if (formError != null) {
        debugPrint(
          'Privacy options form error: '
          '${formError.errorCode} '
          '${formError.message}',
        );
      }
    });
  }
}
