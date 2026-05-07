class Series {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String genre;
  final int year;
  final double rating;
  final int episodeCount;
  final DateTime createdAt;

  Series({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.genre,
    required this.year,
    required this.rating,
    required this.episodeCount,
    required this.createdAt,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      genre: json['genre'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      episodeCount: json['episodeCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
      'genre': genre,
      'year': year,
      'rating': rating,
      'episodeCount': episodeCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
