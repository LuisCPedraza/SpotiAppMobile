import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/models/models.dart';

class SpotifyService {
  String? _accessToken;
  DateTime? _expiresAt;
  bool _lastTopTracksUsedFallback = false;

  bool get lastTopTracksUsedFallback => _lastTopTracksUsedFallback;

  String get _clientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  String get _clientSecret => dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  Future<String> _getAccessToken() async {
    final now = DateTime.now();
    if (_accessToken != null &&
        _expiresAt != null &&
        now.isBefore(_expiresAt!)) {
      return _accessToken!;
    }

    if (_clientId.isEmpty || _clientSecret.isEmpty) {
      throw Exception(
        'Faltan SPOTIFY_CLIENT_ID o SPOTIFY_CLIENT_SECRET en .env',
      );
    }

    final auth = base64Encode(utf8.encode('$_clientId:$_clientSecret'));
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $auth',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo autenticar con Spotify: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    _accessToken = data['access_token'] as String?;

    final expiresIn = (data['expires_in'] as num? ?? 3600).toInt();
    _expiresAt = now.add(Duration(seconds: expiresIn - 60));

    if (_accessToken == null || _accessToken!.isEmpty) {
      throw Exception('Spotify no devolvio access token valido');
    }

    return _accessToken!;
  }

  Future<List<SpotifyAlbum>> getNewReleases() async {
    final token = await _getAccessToken();

    // Usar /v1/search para obtener artistas populares en varios géneros
    // Como fallback a browse/new-releases que requiere permisos especiales
    final popularSearches = ['genre:pop', 'genre:rock', 'genre:hip-hop'];

    final albums = <SpotifyAlbum>[];

    for (final query in popularSearches) {
      final uri = Uri.https('api.spotify.com', '/v1/search', {
        'q': query,
        'type': 'artist',
        'limit': '8',
      });

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        continue;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final artistsBlock = data['artists'] as Map<String, dynamic>? ?? {};
      final items = artistsBlock['items'] as List<dynamic>? ?? [];

      for (final artist in items.cast<Map<String, dynamic>>()) {
        String imageUrl = '';
        final images = artist['images'] as List<dynamic>?;
        if (images != null && images.isNotEmpty) {
          final firstImage = images[0] as Map<String, dynamic>?;
          imageUrl = firstImage?['url'] as String? ?? '';
        }

        albums.add(
          SpotifyAlbum(
            id: artist['id'] as String? ?? '',
            name: artist['name'] as String? ?? 'Unknown',
            imageUrl: imageUrl,
            artistName: artist['name'] as String? ?? 'Unknown',
            artistId: artist['id'] as String? ?? '',
          ),
        );
      }

      if (albums.length >= 24) break;
    }

    return albums.take(24).toList();
  }

  Future<List<SpotifyArtist>> searchArtists(String query) async {
    final token = await _getAccessToken();

    final uri = Uri.https('api.spotify.com', '/v1/search', {
      'q': query,
      'type': 'artist',
      'limit': '10',
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error buscando artistas: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final artistsBlock = data['artists'] as Map<String, dynamic>? ?? {};
    final items = artistsBlock['items'] as List<dynamic>? ?? [];

    // Fallback: algunos términos devuelven mejor resultado con prefijo artist:
    if (items.isEmpty && !query.toLowerCase().startsWith('artist:')) {
      final fallbackUri = Uri.https('api.spotify.com', '/v1/search', {
        'q': 'artist:$query',
        'type': 'artist',
        'limit': '10',
      });

      final fallbackResponse = await http.get(
        fallbackUri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (fallbackResponse.statusCode == 200) {
        final fallbackData =
            jsonDecode(fallbackResponse.body) as Map<String, dynamic>;
        final fallbackArtists =
            fallbackData['artists'] as Map<String, dynamic>? ?? {};
        final fallbackItems = fallbackArtists['items'] as List<dynamic>? ?? [];

        return fallbackItems
            .cast<Map<String, dynamic>>()
            .map(SpotifyArtist.fromMap)
            .toList();
      }
    }

    return items
        .cast<Map<String, dynamic>>()
        .map(SpotifyArtist.fromMap)
        .toList();
  }

  Future<List<SpotifyTrack>> getArtistTopTracks(String artistId) async {
    _lastTopTracksUsedFallback = false;
    final token = await _getAccessToken();

    final uri = Uri.https(
      'api.spotify.com',
      '/v1/artists/$artistId/top-tracks',
      {'market': 'US'},
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final tracks = data['tracks'] as List<dynamic>? ?? [];

      return tracks
          .cast<Map<String, dynamic>>()
          .take(10)
          .map(SpotifyTrack.fromMap)
          .toList();
    }

    // Fallback para credenciales con restricciones (403 en top-tracks):
    // 1) obtener nombre del artista por ID
    // 2) buscar tracks por nombre del artista
    _lastTopTracksUsedFallback = true;
    final artistUri = Uri.https('api.spotify.com', '/v1/artists/$artistId');
    final artistResponse = await http.get(
      artistUri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (artistResponse.statusCode != 200) {
      throw Exception('Error cargando top tracks: ${response.body}');
    }

    final artistData = jsonDecode(artistResponse.body) as Map<String, dynamic>;
    final artistName = (artistData['name'] ?? '').toString();

    if (artistName.isEmpty) {
      throw Exception('No se pudo resolver el artista para cargar canciones.');
    }

    final searchUri = Uri.https('api.spotify.com', '/v1/search', {
      'q': 'artist:$artistName',
      'type': 'track',
      'limit': '10',
      'market': 'US',
    });

    final searchResponse = await http.get(
      searchUri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (searchResponse.statusCode != 200) {
      throw Exception('Error cargando top tracks: ${response.body}');
    }

    final searchData = jsonDecode(searchResponse.body) as Map<String, dynamic>;
    final tracksBlock = searchData['tracks'] as Map<String, dynamic>? ?? {};
    final items = tracksBlock['items'] as List<dynamic>? ?? [];

    final mappedTracks = items.cast<Map<String, dynamic>>();

    final byArtistId = mappedTracks
        .where((track) {
          final artists = (track['artists'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
          return artists.any(
            (artist) => (artist['id'] ?? '').toString() == artistId,
          );
        })
        .take(10)
        .map(SpotifyTrack.fromMap)
        .toList();

    if (byArtistId.isNotEmpty) {
      return byArtistId;
    }

    return mappedTracks
        .cast<Map<String, dynamic>>()
        .take(10)
        .map(SpotifyTrack.fromMap)
        .toList();
  }
}
