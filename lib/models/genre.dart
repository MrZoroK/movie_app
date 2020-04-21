import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable(explicitToJson: true)
class Genre {
  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
  Map<String, dynamic> toJson() => _$GenreToJson(this);  

  Genre(
    {this.id,
    this.name});

  @override
  bool operator ==(covariant Genre other) {
    return other is Genre && id == other.id;
  }
  @override
  int get hashCode => super.hashCode;
}