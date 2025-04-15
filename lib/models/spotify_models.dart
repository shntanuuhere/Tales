class SpotifyTrack {
  final String id;
  final String name;
  final String artistName;
  final String albumName;
  final String? imageUrl;
  final Duration duration;

  SpotifyTrack({
    required this.id,
    required this.name,
    required this.artistName,
    required this.albumName,
    this.imageUrl,
    required this.duration,
  });

  factory SpotifyTrack.fromJson(Map<String, dynamic> json) {
    final track = json['track'] ?? json;
    final artists = track['artists'] as List;
    final album = track['album'] as Map<String, dynamic>;
    final images = album['images'] as List;

    return SpotifyTrack(
      id: track['id'],
      name: track['name'],
      artistName: artists.map((artist) => artist['name']).join(', '),
      albumName: album['name'],
      imageUrl: images.isNotEmpty ? images[0]['url'] : null,
      duration: Duration(milliseconds: track['duration_ms']),
    );
  }
}

class SpotifyPlaylist {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String ownerName;
  final int trackCount;

  SpotifyPlaylist({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.ownerName,
    required this.trackCount,
  });

  factory SpotifyPlaylist.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List;
    return SpotifyPlaylist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: images.isNotEmpty ? images[0]['url'] : null,
      ownerName: json['owner']['display_name'] ?? 'Unknown',
      trackCount: json['tracks']['total'],
    );
  }
}