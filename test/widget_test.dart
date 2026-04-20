import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canciones_app/models/models.dart';
import 'package:canciones_app/providers/songs_provider.dart';
import 'package:canciones_app/screens/artist_screen.dart';
import 'package:canciones_app/screens/home_screen.dart';
import 'package:canciones_app/screens/search_screen.dart';
import 'package:provider/provider.dart';

class TestSongsProvider extends SongsProvider {
  @override
  Future<void> loadNewReleases() async {
    newReleases = [
      SpotifyAlbum(
        id: 'a1',
        name: 'Album de prueba',
        imageUrl: '',
        artistName: 'Artista demo',
        artistId: 'artist-1',
      ),
    ];
    isLoadingHome = false;
    errorMessage = null;
    notifyListeners();
  }

  @override
  Future<void> searchArtists(String query) async {
    artists = [
      SpotifyArtist(
        id: 'artist-1',
        name: 'Artista demo',
        imageUrl: '',
        followers: 123,
      ),
    ];
    isSearchingArtists = false;
    errorMessage = null;
    notifyListeners();
  }

  @override
  Future<void> loadTopTracks(String artistId) async {
    topTracks = [
      SpotifyTrack(
        id: 'track-1',
        name: 'Cancion demo',
        albumName: 'Album demo',
        previewUrl: null,
        durationMs: 90000,
      ),
    ];
    isLoadingTracks = false;
    isTopTracksFallback = false;
    errorMessage = null;
    notifyListeners();
  }
}

void main() {
  testWidgets('HomeScreen renderiza titulo y grid de albums', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<SongsProvider>(
        create: (_) => TestSongsProvider(),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Canciones App'), findsOneWidget);
    expect(find.text('Album de prueba'), findsOneWidget);
    expect(find.byIcon(Icons.search_outlined), findsOneWidget);
  });

  testWidgets('SearchScreen muestra campo de busqueda', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<SongsProvider>(
        create: (_) => TestSongsProvider(),
        child: const MaterialApp(home: SearchScreen()),
      ),
    );

    expect(find.text('Buscar artista'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Escribe un artista...'), findsOneWidget);
  });

  testWidgets('ArtistScreen muestra artista y track', (WidgetTester tester) async {
    final artist = SpotifyArtist(
      id: 'artist-1',
      name: 'Artista demo',
      imageUrl: '',
      followers: 123,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<SongsProvider>(
        create: (_) => TestSongsProvider(),
        child: MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute<void>(
              settings: RouteSettings(name: settings.name, arguments: artist),
              builder: (_) => const ArtistScreen(),
            );
          },
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Artista demo'), findsWidgets);
    expect(find.text('Cancion demo'), findsOneWidget);
  });
}
