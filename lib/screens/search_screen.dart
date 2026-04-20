import 'dart:async';

import 'package:flutter/material.dart';
import 'package:canciones_app/models/models.dart';
import 'package:canciones_app/providers/songs_provider.dart';
import 'package:canciones_app/screens/screens.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = 'search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged(BuildContext context, String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      context.read<SongsProvider>().searchArtists(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar artista')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Escribe un artista...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _onChanged(context, value),
              onSubmitted: (value) =>
                  context.read<SongsProvider>().searchArtists(value),
            ),
          ),
          if (provider.isSearchingArtists)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (provider.errorMessage != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else if (_searchController.text.trim().isNotEmpty &&
              provider.artists.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No se encontraron artistas para esa búsqueda.'),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: provider.artists.length,
                separatorBuilder: (_, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final artist = provider.artists[index];
                  return _ArtistTile(artist: artist);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ArtistTile extends StatelessWidget {
  const _ArtistTile({required this.artist});

  final SpotifyArtist artist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: artist.imageUrl.isNotEmpty
            ? NetworkImage(artist.imageUrl)
            : const AssetImage('assets/no-image.jpg') as ImageProvider,
      ),
      title: Text(artist.name),
      subtitle: Text('Seguidores: ${artist.followers}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pushNamed(context, ArtistScreen.routeName, arguments: artist);
      },
    );
  }
}
