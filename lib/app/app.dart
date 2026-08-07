import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'theme/app_theme.dart';

class MovementBreakApp extends StatelessWidget {
  const MovementBreakApp({
    required this.appState,
    required this.navigatorKey,
    super.key,
  });

  final AppState appState;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Movement Break',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const OnboardingScreen(),
      ),
    );
  }
}
