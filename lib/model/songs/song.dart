class Song {
  final String id;
  final String title;
  final String artistId;
  final Duration duration;
  final int likeCount;
  final Uri imageUrl;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.duration,
    required this.imageUrl,
    required this.likeCount,
  });

  Song copyWith({
    String? title,
    String? artistId,
    Duration? duration,
    Uri? imageUrl,
    int? likeCount,
  }) => Song(
    id: id,
    title: title ?? this.title,
    artistId: artistId ?? this.artistId,
    duration: duration ?? this.duration,
    imageUrl: imageUrl ?? this.imageUrl,
    likeCount: likeCount ?? this.likeCount,
  );

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist id: $artistId, duration: $duration, likeCount: $likeCount)';
  }
}
