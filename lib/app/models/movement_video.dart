class MovementVideo {
  const MovementVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String thumbnailUrl;

  factory MovementVideo.fromPlaylistItem(Map<String, dynamic> item) {
    final snippet =
        item['snippet'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final contentDetails =
        item['contentDetails'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final thumbnails =
        snippet['thumbnails'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final mediumThumbnail =
        thumbnails['medium'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final defaultThumbnail =
        thumbnails['default'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return MovementVideo(
      id: contentDetails['videoId'] as String? ?? '',
      title: snippet['title'] as String? ?? 'Movement Break',
      thumbnailUrl:
          mediumThumbnail['url'] as String? ??
          defaultThumbnail['url'] as String? ??
          '',
    );
  }
}
