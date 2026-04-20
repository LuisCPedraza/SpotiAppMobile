import 'package:flutter/material.dart';
import 'package:canciones_app/models/models.dart';
import 'package:canciones_app/services/spotify_service.dart';

class SongsProvider extends ChangeNotifier {
  final SpotifyService _spotifyService = SpotifyService();

  // Compatibilidad temporal con pantallas legacy que aun referencian Song.
  List<Song> onDisplaySongs = [];

  List<SpotifyAlbum> newReleases = [];
  List<SpotifyArtist> artists = [];
  List<SpotifyTrack> topTracks = [];

  bool isLoadingHome = false;
  bool isSearchingArtists = false;
  bool isLoadingTracks = false;
  bool isTopTracksFallback = false;

  String? errorMessage;

  SongsProvider() {
    loadNewReleases();
  }

  Future<void> loadNewReleases() async {
    isLoadingHome = true;
    errorMessage = null;
    notifyListeners();

    try {
      newReleases = await _spotifyService.getNewReleases();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoadingHome = false;
      notifyListeners();
    }
  }

  Future<void> searchArtists(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      artists = [];
      notifyListeners();
      return;
    }

    isSearchingArtists = true;
    errorMessage = null;
    notifyListeners();

    try {
      artists = await _spotifyService.searchArtists(cleanQuery);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isSearchingArtists = false;
      notifyListeners();
    }
  }

  Future<void> loadTopTracks(String artistId) async {
    isLoadingTracks = true;
    isTopTracksFallback = false;
    errorMessage = null;
    notifyListeners();

    try {
      topTracks = await _spotifyService.getArtistTopTracks(artistId);
      isTopTracksFallback = _spotifyService.lastTopTracksUsedFallback;
    } catch (error) {
      errorMessage = error.toString();
      topTracks = [];
      isTopTracksFallback = false;
    } finally {
      isLoadingTracks = false;
      notifyListeners();
    }
  }
}
