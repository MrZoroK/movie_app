
import 'package:json_annotation/json_annotation.dart';
part 'movie_base.g.dart';

@JsonSerializable()
class MovieBase {
  int id;
  String title;
  String overview;

  @JsonKey(name: "poster_path")
  String posterPath;
  @JsonKey(name: "backdrop_path")
  String backdropPath;

  factory MovieBase.fromJson(Map<String, dynamic> json) => _$MovieBaseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieBaseToJson(this);  
  MovieBase(
    {this.id,
    this.title,
    this.overview,
    this.posterPath,
    this.backdropPath});
}