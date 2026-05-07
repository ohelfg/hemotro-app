class Episode {
  final String id;
  final String seriesId;
  final String title;
  final String description;
  final int episodeNumber;
  final int seasonNumber;
  final String? video1080pUrl;
  final String? video720pUrl;
  final String? video480pUrl;
  final String? video360pUrl;
  final String? thumbnailUrl;
  final Duration duration;
  final DateTime releaseDate;
  final DateTime createdAt;

  Episode({
    required this.id,
    required this.seriesId,
    required this.title,
    required this.description,
    required this.episodeNumber,
    required this.seasonNumber,
    this.video1080pUrl,
    this.video720pUrl,
    this.video480pUrl,
    this.video360pUrl,
    this.thumbnailUrl,
    required this.duration,
    required this.releaseDate,
    required this.createdAt,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? '',
      seriesId: json['seriesId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 0,
      seasonNumber: json['seasonNumber'] ?? 1,
      video1080pUrl: json['video1080pUrl'],
      video720pUrl: json['video720pUrl'],
      video480pUrl: json['video480pUrl'],
      video360pUrl: json['video360pUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: Duration(
        seconds: json['duration'] ?? 0,
      ),
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seriesId': seriesId,
      'title': title,
      'description': description,
      'episodeNumber': episodeNumber,
      'seasonNumber': seasonNumber,
      'video1080pUrl': video1080pUrl,
      'video720pUrl': video720pUrl,
      'video480pUrl': video480pUrl,
      'video360pUrl': video360pUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration.inSeconds,
      'releaseDate': releaseDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String? getVideoUrlForQuality(String quality) {
    switch (quality) {
      case '1080p':
        return video1080pUrl;
      case '720p':
        return video720pUrl;
      case '480p':
        return video480pUrl;
      case '360p':
        return video360pUrl;
      default:
        return video720pUrl ?? video480pUrl ?? video360pUrl ?? video1080pUrl;
    }
  }
}
