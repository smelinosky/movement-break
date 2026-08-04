import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/movement_video.dart';

class YoutubePlaylistException implements Exception {
  const YoutubePlaylistException(this.message);

  final String message;

  @override
  String toString() => message;
}

class YoutubePlaylistService {
  YoutubePlaylistService({http.Client? client})
    : _client = client ?? http.Client();

  static const String playlistId = 'PLLJJDEFGimro';

  final http.Client _client;

  Future<List<MovementVideo>> fetchVideos() async {
    final apiKey = dotenv.env['YOUTUBE_API_KEY'];

    if (apiKey == null || apiKey.trim().isEmpty) {
      throw const YoutubePlaylistException(
        'The YouTube API key is missing from the .env file.',
      );
    }

    final videos = <MovementVideo>[];
    String? nextPageToken;

    do {
      final queryParameters = <String, String>{
        'part': 'snippet,contentDetails',
        'playlistId': playlistId,
        'maxResults': '50',
        'key': apiKey,
      };

      if (nextPageToken != null) {
        queryParameters['pageToken'] = nextPageToken;
      }

      final uri = Uri.https(
        'www.googleapis.com',
        '/youtube/v3/playlistItems',
        queryParameters,
      );

      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        throw YoutubePlaylistException(
          'YouTube returned status ${response.statusCode}: '
          '${response.body}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const YoutubePlaylistException(
          'YouTube returned an unexpected response.',
        );
      }

      final items = decoded['items'];

      if (items is List) {
        for (final item in items) {
          if (item is! Map<String, dynamic>) {
            continue;
          }

          final video = MovementVideo.fromPlaylistItem(item);

          final normalizedTitle = video.title.toLowerCase();

          final unavailable =
              video.id.isEmpty ||
              normalizedTitle == 'private video' ||
              normalizedTitle == 'deleted video';

          if (!unavailable) {
            videos.add(video);
          }
        }
      }

      nextPageToken = decoded['nextPageToken'] as String?;
    } while (nextPageToken != null);

    if (videos.isEmpty) {
      throw const YoutubePlaylistException(
        'No available movement videos were found.',
      );
    }

    return videos;
  }

  void dispose() {
    _client.close();
  }
}
