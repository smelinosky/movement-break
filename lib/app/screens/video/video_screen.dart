import 'dart:math';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../models/movement_video.dart';
import '../../services/youtube_playlist_service.dart';
import '../../theme/app_colors.dart';
import '../completion/completion_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  static String? _lastPlayedVideoId;

  final YoutubePlaylistService _playlistService = YoutubePlaylistService();

  final Random _random = Random();

  late final YoutubePlayerController _controller;

  List<MovementVideo> _videos = const [];
  MovementVideo? _currentVideo;

  bool _isLoading = true;
  bool _isChangingVideo = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
        playsInline: true,
        enableCaption: true,
        strictRelatedVideos: true,
      ),
    );

    _loadPlaylistAndStartVideo();
  }

  Future<void> _loadPlaylistAndStartVideo() async {
    try {
      final videos = await _playlistService.fetchVideos();

      if (!mounted) {
        return;
      }

      _videos = videos;

      final firstVideo = _pickRandomVideo(excludedVideoId: _lastPlayedVideoId);

      setState(() {
        _currentVideo = firstVideo;
        _isLoading = false;
        _errorMessage = null;
      });

      _lastPlayedVideoId = firstVideo.id;

      await _controller.loadVideoById(videoId: firstVideo.id);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'We could not load a movement right now. Please try again.';
      });

      debugPrint('Playlist loading error: $error');
    }
  }

  MovementVideo _pickRandomVideo({String? excludedVideoId}) {
    if (_videos.isEmpty) {
      throw StateError('No movement videos are available.');
    }

    if (_videos.length == 1) {
      return _videos.first;
    }

    final availableVideos = _videos
        .where((video) => video.id != excludedVideoId)
        .toList();

    return availableVideos[_random.nextInt(availableVideos.length)];
  }

  Future<void> _chooseDifferentMovement() async {
    if (_videos.isEmpty || _isChangingVideo) {
      return;
    }

    setState(() {
      _isChangingVideo = true;
    });

    try {
      final nextVideo = _pickRandomVideo(excludedVideoId: _currentVideo?.id);

      setState(() {
        _currentVideo = nextVideo;
      });

      _lastPlayedVideoId = nextVideo.id;

      await _controller.loadVideoById(videoId: nextVideo.id);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'We could not load another movement. Please try again.',
          ),
        ),
      );

      debugPrint('Video change error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isChangingVideo = false;
        });
      }
    }
  }

  Future<void> _skipMovement() async {
    await _controller.pauseVideo();

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  Future<void> _completeMovement() async {
    await _controller.pauseVideo();

    if (!mounted) {
      return;
    }

    await context.read<AppState>().completeMovement();
    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const CompletionScreen()),
    );
  }

  Future<void> _retry() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _loadPlaylistAndStartVideo();
  }

  @override
  void dispose() {
    _controller.close();
    _playlistService.dispose();
    super.dispose();
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
        child: SafeArea(top: false, child: _buildContent(theme)),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 56,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _retry, child: const Text('Try Again')),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
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
            child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
          ),
          const SizedBox(height: 16),
          if (_currentVideo != null)
            Text(
              _currentVideo!.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          const SizedBox(height: 20),
          TextButton(onPressed: _skipMovement, child: const Text('Skip')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _isChangingVideo ? null : _chooseDifferentMovement,
            child: _isChangingVideo
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Choose a Different Movement'),
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
    );
  }
}
