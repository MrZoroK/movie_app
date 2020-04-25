// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieBase _$MovieBaseFromJson(Map<String, dynamic> json) {
  return MovieBase(
    id: json['id'] as int,
    title: json['title'] as String,
    overview: json['overview'] as String,
    voteAverage: (json['vote_average'] as num)?.toDouble(),
    releaseDate: json['release_date'] as String,
    posterPath: json['poster_path'] as String,
    backdropPath: json['backdrop_path'] as String,
    genreIds: (json['genre_ids'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$MovieBaseToJson(MovieBase instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'vote_average': instance.voteAverage,
      'release_date': instance.releaseDate,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
    };
