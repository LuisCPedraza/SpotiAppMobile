import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:canciones_app/models/models.dart';
import 'package:canciones_app/providers/songs_provider.dart';
import 'package:provider/provider.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});

  static const String routeName = 'artist';

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingTrackId;
  String? _loadedArtistId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final artist = ModalRoute.of(context)!.settings.arguments as SpotifyArtist;
    if (_loadedArtistId == artist.id) return;

    _loadedArtistId = artist.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SongsProvider>().loadTopTracks(artist.id);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPreview(SpotifyTrack track) async {
    if (track.previewUrl == null || track.previewUrl!.isEmpty) return;

    if (_playingTrackId == track.id) {
      await _audioPlayer.stop();
      if (!mounted) return;
      setState(() => _playingTrackId = null);
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(track.previewUrl!));

    if (!mounted) return;
    setState(() => _playingTrackId = track.id);
  }

  @override
  Widget build(BuildContext context) {
    final artist = ModalRoute.of(context)!.settings.arguments as SpotifyArtist;

    return Scaffold(
      appBar: AppBar(title: Text(artist.name)),
      body: Column(
        children: [
          _ArtistHeader(artist: artist),
          Consumer<SongsProvider>(
            builder: (context, provider, child) {
              if (!provider.isTopTracksFallback) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Color(0xFF374151),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Top tracks (fallback por busqueda)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<SongsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoadingTracks) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (provider.topTracks.isEmpty) {
                  return const Center(
                    child: Text('No hay tracks disponibles para este artista.'),
                  );
                }

                return ListView.builder(
                  itemCount: provider.topTracks.length,
                  itemBuilder: (context, index) {
                    final track = provider.topTracks[index];
                    final canPreview =
                        track.previewUrl != null &&
                        track.previewUrl!.isNotEmpty;
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(track.name),
                      subtitle: Text(
                        '${track.albumName} · ${track.formattedDuration}',
                      ),
                      trailing: IconButton(
                        onPressed: canPreview
                            ? () => _playPreview(track)
                            : null,
                        icon: Icon(
                          _playingTrackId == track.id
                              ? Icons.stop_circle
                              : Icons.play_circle,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArtistHeader extends StatelessWidget {
  const _ArtistHeader({required this.artist});

  final SpotifyArtist artist;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF3F4F6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: artist.imageUrl.isNotEmpty
                ? NetworkImage(artist.imageUrl)
                : const AssetImage('assets/no-image.jpg') as ImageProvider,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Seguidores: ${artist.followers}',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
