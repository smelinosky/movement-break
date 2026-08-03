import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';

void main() {
  runApp(const MovementBreakApp());
}

class MovementBreakApp extends StatelessWidget {
  const MovementBreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movement Break',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const ThemePreviewScreen(),
    );
  }
}

class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement Break'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Movement Break',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Exercise snacks to build healthy movement habits',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'BREAKS COMPLETED',
                        style: theme.textTheme.labelMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '3 / 4',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Great job! Keep it going!!',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.directions_walk),
                label: const Text("LET'S MOVE!"),
              ),
              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () {},
                child: const Text('Choose a Different Movement'),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {},
                child: const Text('Skip This Movement'),
              ),
              const SizedBox(height: 28),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Next Reminder'),
                  subtitle: const Text('2:15 PM · in 28 minutes'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 24),

              CheckboxListTile(
                value: true,
                onChanged: (_) {},
                title: const Text('Sound'),
                subtitle: const Text('Play a sound for reminders'),
                controlAffinity: ListTileControlAffinity.trailing,
              ),

              SwitchListTile(
                value: true,
                onChanged: (_) {},
                title: const Text('Vibration'),
                subtitle: const Text('Vibrate for reminders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
