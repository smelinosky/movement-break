import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../theme/app_colors.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController.fromVideoId(
      videoId: '2YmJyQy8lhM',
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
        playsInline: true,
        enableCaption: true,
        strictRelatedVideos: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _skipMovement() {
    _controller.pauseVideo();
    Navigator.pop(context);
  }

  void _chooseDifferentMovement() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A different movement will load here.')),
    );
  }

  void _completeMovement() {
    _controller.pauseVideo();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Completion screen will open here.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Movement Break')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.backgroundDark],
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(onPressed: _skipMovement, child: const Text('Skip')),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _chooseDifferentMovement,
                  child: const Text('Choose a Different Movement'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _completeMovement,
                  child: const Text('Done'),
                ),
                const SizedBox(height: 18),
                Text(
                  'Take your time. Move in a way that feels comfortable.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
