import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  static const String _androidTestAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static const String _iosTestAdUnitId =
      'ca-app-pub-3940256099942544/2934735716';

  String get _adUnitId {
    // Keep iOS on Google's test banner during TestFlight testing.
    if (Platform.isIOS) {
      return _iosTestAdUnitId;
    }

    // Android debug/development builds use Google's test banner.
    if (!kReleaseMode && Platform.isAndroid) {
      return _androidTestAdUnitId;
    }

    // Android production builds use the real Movement Break banner ID.
    if (Platform.isAndroid) {
      final productionId = dotenv.env['ADMOB_ANDROID_BANNER_ID'];

      if (productionId == null || productionId.isEmpty) {
        throw StateError('ADMOB_ANDROID_BANNER_ID is missing from .env.');
      }

      return productionId;
    }

    throw UnsupportedError('Banner ads are not configured for this platform.');
  }

  @override
  void initState() {
    super.initState();

    _loadBanner();
  }

  void _loadBanner() {
    final bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });

          if (Platform.isIOS) {
            debugPrint('iOS test banner ad loaded.');
          } else if (kReleaseMode) {
            debugPrint('Android production banner ad loaded.');
          } else {
            debugPrint('Android test banner ad loaded.');
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');

          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox(height: 50);
    }

    return Center(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
