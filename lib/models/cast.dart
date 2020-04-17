import 'package:json_annotation/json_annotation.dart';
part 'cast.g.dart';

@JsonSerializable()
class Cast {
  String character;
  int id;
  String name;
  int order;
  @JsonKey(name: "profile_path")
  String profilePath;

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
  Map<String, dynamic> toJson() => _$CastToJson(this);  

  Cast(
    {this.character,
    this.id,
    this.name,
    this.order,
    this.profilePath});
}