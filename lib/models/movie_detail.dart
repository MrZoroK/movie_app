import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/models.dart';
part 'movie_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieDetail extends MovieBase {
  @JsonKey(name: "vote_average")
  double voteAverage;
  @JsonKey(name: "release_date")
  DateTime releaseDate;
  List<Genre> genres;

  factory MovieDetail.fromJson(Map<String, dynamic> json) => _$MovieDetailFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailToJson(this);  
  MovieDetail(
    {int id, String title, String overview, String posterPath, String backdropPath,
    this.voteAverage,
    this.releaseDate,
    this.genres})
    : super(id: id, title: title, overview: overview, posterPath: posterPath, backdropPath: backdropPath);
}