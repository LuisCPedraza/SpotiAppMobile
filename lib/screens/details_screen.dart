import 'package:flutter/material.dart';
import 'package:canciones_app/models/models.dart';
import 'package:canciones_app/providers/songs_provider.dart';
import 'package:canciones_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DetailArguments {
  final Song song;
  final String heroTag;

  const DetailArguments({required this.song, required this.heroTag});
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static const double _edgeActivationWidth = 24;
  static const double _popDragThreshold = 100;

  bool _trackingEdgeSwipe = false;
  double _startX = 0;
  double _dragDistance = 0;

  void _handlePointerDown(PointerDownEvent event) {
    _trackingEdgeSwipe = event.position.dx <= _edgeActivationWidth;
    _startX = event.position.dx;
    _dragDistance = 0;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_trackingEdgeSwipe) return;

    final drag = event.position.dx - _startX;
    _dragDistance = drag > 0 ? drag : 0;
  }

  void _handlePointerUpOrCancel() {
    if (_trackingEdgeSwipe && _dragDistance >= _popDragThreshold) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    _trackingEdgeSwipe = false;
    _startX = 0;
    _dragDistance = 0;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as DetailArguments;
    final Song song = arguments.song;
    final songsProvider = Provider.of<SongsProvider>(context);
    final otherSongs = songsProvider.onDisplaySongs
        .where((item) => item.id != song.id)
        .toList();

    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: (_) => _handlePointerUpOrCancel(),
      onPointerCancel: (_) => _handlePointerUpOrCancel(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _CustomAppBar(song: song, heroTag: arguments.heroTag),
            SliverList(
              delegate: SliverChildListDelegate([
                _PosterAndTitle(song: song, heroTag: arguments.heroTag),
                _Overview(song: song),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Text(
                    'Tambien te puede gustar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                CastingCards(songs: otherSongs),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Song song;
  final String heroTag;

  const _CustomAppBar({required this.song, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 240,
      floating: false,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.black45,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            color: Colors.white,
            tooltip: 'Volver',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.black38,
          child: Text(
            song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: const [Shadow(color: Colors.black87, blurRadius: 10)],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 350),
              builder: (context, opacity, child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(song.fullBackdropPath),
                fit: BoxFit.cover,
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.black54],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Song song;
  final String heroTag;

  const _PosterAndTitle({required this.song, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: heroTag,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 300),
              builder: (context, opacity, child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(song.fullPosterImg),
                  width: 110,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 6),
                Text(
                  song.originalTitle,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        song.voteAverage.toStringAsFixed(1),
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Song song;

  const _Overview({required this.song});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        song.overview,
        textAlign: TextAlign.justify,
        style: textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.9),
          height: 1.45,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
