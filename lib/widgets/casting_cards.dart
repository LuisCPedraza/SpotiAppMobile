import 'package:flutter/material.dart';
import 'package:canciones_app/models/models.dart';
import 'package:canciones_app/screens/details_screen.dart';

class CastingCards extends StatelessWidget {
  final List<Song> songs;

  const CastingCards({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: double.infinity,
        height: 190,
        alignment: Alignment.center,
        child: const Text('No hay otras canciones para mostrar'),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      height: 190,
      child: ListView.builder(
        itemCount: songs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int index) => _CastCard(song: songs[index]),
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  final Song song;

  const _CastCard({required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          'detail',
          arguments: DetailArguments(
            song: song,
            heroTag: 'detail-related-${song.id}',
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 110,
        height: 170,
        child: Column(
          children: [
            Hero(
              tag: 'detail-related-${song.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(song.fullPosterImg),
                  width: 110,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              song.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
