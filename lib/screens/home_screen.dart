import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/songs_provider.dart';
import 'package:peliculas_app/screens/screens.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songsProvider = Provider.of<SongsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotiapp Mobile'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, SearchScreen.routeName),
            icon: const Icon(Icons.search_outlined),
            tooltip: 'Buscar',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: songsProvider.loadNewReleases,
        child: Builder(
          builder: (context) {
            if (songsProvider.isLoadingHome &&
                songsProvider.newReleases.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (songsProvider.errorMessage != null &&
                songsProvider.newReleases.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 140),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      songsProvider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemCount: songsProvider.newReleases.length,
              itemBuilder: (context, index) {
                final album = songsProvider.newReleases[index];
                return _AlbumCard(album: album);
              },
            );
          },
        ),
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({required this.album});

  final SpotifyAlbum album;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.pushNamed(
          context,
          ArtistScreen.routeName,
          arguments: SpotifyArtist(
            id: album.artistId,
            name: album.artistName,
            imageUrl: album.imageUrl,
            followers: 0,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/loading.gif'),
                  image: album.imageUrl.isNotEmpty
                      ? NetworkImage(album.imageUrl)
                      : const AssetImage('assets/no-image.jpg')
                            as ImageProvider,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    album.artistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
