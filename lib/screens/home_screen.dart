import 'package:flutter/material.dart';
import 'package:peliculas_app/widgets/card_swiper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en Cartelera'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined)),
        ],
      ),
      body: Column(
        children: [
          CardSwiper(),
          //listado de peliculas horizontal
        ],
      ),
    );
  }
}
