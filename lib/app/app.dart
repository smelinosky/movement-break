import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'theme/app_theme.dart';

class MovementBreakApp extends StatelessWidget {
  const MovementBreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movement Break',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
