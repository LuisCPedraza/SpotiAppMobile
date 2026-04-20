import 'package:canciones_app/models/models.dart';
import 'package:canciones_app/screens/details_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CardSwiper extends StatelessWidget {
  final List<Song> songs;
  const CardSwiper({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (songs.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: songs.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (BuildContext context, int index) {
          final song = songs[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'detail',
              arguments: DetailArguments(
                song: song,
                heroTag: 'card-swiper-${song.id}',
              ),
            ),
            child: Hero(
              tag: 'card-swiper-${song.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(song.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
