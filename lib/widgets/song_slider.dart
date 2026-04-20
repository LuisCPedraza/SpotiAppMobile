import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/screens/details_screen.dart';

class SongSlider extends StatelessWidget {
  final List<Song> songs;

  const SongSlider({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (_, int index) => _SongPoster(song: songs[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SongPoster extends StatelessWidget {
  final Song song;

  const _SongPoster({required this.song});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 130,
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'detail',
              arguments: DetailArguments(
                song: song,
                heroTag: 'song-slider-${song.id}',
              ),
            ),
            child: Hero(
              tag: 'song-slider-${song.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(song.fullPosterImg),
                  width: 130,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                song.voteAverage.toStringAsFixed(1),
                style: textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
