class SpotifyAlbum {
  SpotifyAlbum({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artistName,
    required this.artistId,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String artistName;
  final String artistId;

  factory SpotifyAlbum.fromMap(Map<String, dynamic> map) {
    final images = (map['images'] as List<dynamic>? ?? []);
    final artists = (map['artists'] as List<dynamic>? ?? []);

    final firstArtist = artists.isNotEmpty
        ? artists.first as Map<String, dynamic>
        : <String, dynamic>{};

    final firstImage = images.isNotEmpty
        ? images.first as Map<String, dynamic>
        : <String, dynamic>{};

    return SpotifyAlbum(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? 'Sin titulo').toString(),
      imageUrl: (firstImage['url'] ?? '').toString(),
      artistName: (firstArtist['name'] ?? 'Artista desconocido').toString(),
      artistId: (firstArtist['id'] ?? '').toString(),
    );
  }
}

class SpotifyArtist {
  SpotifyArtist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.followers,
  });

  final String id;
  final String name;
  final String imageUrl;
  final int followers;

  factory SpotifyArtist.fromMap(Map<String, dynamic> map) {
    final images = (map['images'] as List<dynamic>? ?? []);
    final firstImage = images.isNotEmpty
        ? images.first as Map<String, dynamic>
        : <String, dynamic>{};

    final followersMap = map['followers'] as Map<String, dynamic>? ?? {};

    return SpotifyArtist(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? 'Artista desconocido').toString(),
      imageUrl: (firstImage['url'] ?? '').toString(),
      followers: (followersMap['total'] as num? ?? 0).toInt(),
    );
  }
}

class SpotifyTrack {
  SpotifyTrack({
    required this.id,
    required this.name,
    required this.albumName,
    required this.previewUrl,
    required this.durationMs,
  });

  final String id;
  final String name;
  final String albumName;
  final String? previewUrl;
  final int durationMs;

  factory SpotifyTrack.fromMap(Map<String, dynamic> map) {
    final album = map['album'] as Map<String, dynamic>? ?? {};

    return SpotifyTrack(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? 'Sin titulo').toString(),
      albumName: (album['name'] ?? 'Album desconocido').toString(),
      previewUrl: map['preview_url'] as String?,
      durationMs: (map['duration_ms'] as num? ?? 0).toInt(),
    );
  }

  String get formattedDuration {
    final totalSeconds = durationMs ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final secondsText = seconds.toString().padLeft(2, '0');
    return '$minutes:$secondsText';
  }
}
