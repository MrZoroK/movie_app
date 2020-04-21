
import 'package:json_annotation/json_annotation.dart';
part 'movie_base.g.dart';

enum MonthName {
  January,February,March,April,May,June,
  July,August,September,October,November,December
}
extension DateTimeEx on DateTime {
  String get monthAndYear {
    String strMonth = "";
    MonthName.values.forEach((element) {
      if (element.index + 1 == month) {
        strMonth = element.toString().replaceAll("MonthName.", "");
      }
    });
    return strMonth + " $year";
  }
}

@JsonSerializable()
class MovieBase {
  int id;
  String title;
  String overview;

  @JsonKey(name: "vote_average")
  double voteAverage;
  @JsonKey(name: "release_date")
  String releaseDate;

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
    this.voteAverage,
    this.releaseDate,
    this.posterPath,
    this.backdropPath});

  double get voteRate => (voteAverage / 10) * 5;
  String get formatedReleaseDate {
    var ymd = releaseDate.split("-");
    var year = ymd[0];
    var month = int.parse(ymd[1]);
    String strMonth = "";
    MonthName.values.forEach((element) {
      if (element.index + 1 == month) {
        strMonth = element.toString().replaceAll("MonthName.", "");
      }
    });
    return strMonth + " $year";
  }
}