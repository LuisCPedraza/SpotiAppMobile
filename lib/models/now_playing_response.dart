import 'dart:convert';
import 'package:canciones_app/models/song.dart';

class NowPlayingResponse {
  NowPlayingResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final Dates dates;
  final int page;
  final List<Song> results;
  final int totalPages;
  final int totalResults;

  factory NowPlayingResponse.fromJson(String str) {
    return NowPlayingResponse.fromMap(json.decode(str) as Map<String, dynamic>);
  }

  factory NowPlayingResponse.fromMap(Map<String, dynamic> map) {
    return NowPlayingResponse(
      dates: Dates.fromMap(map['dates'] as Map<String, dynamic>),
      page: map['page'] as int,
      results: List<Song>.from(
        (map['results'] as List<dynamic>).map(
          (x) => Song.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPages: map['total_pages'] as int,
      totalResults: map['total_results'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'dates': dates.toMap(),
      'page': page,
      'results': results.map((x) => x.toMap()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}

class Dates {
  Dates({required this.maximum, required this.minimum});

  final DateTime maximum;
  final DateTime minimum;

  factory Dates.fromRawJson(String str) {
    return Dates.fromMap(json.decode(str) as Map<String, dynamic>);
  }

  factory Dates.fromMap(Map<String, dynamic> json) {
    return Dates(
      maximum: DateTime.parse(json['maximum'] as String),
      minimum: DateTime.parse(json['minimum'] as String),
    );
  }

  String toRawJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'maximum': maximum.toIso8601String(),
      'minimum': minimum.toIso8601String(),
    };
  }
}
