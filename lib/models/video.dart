import 'package:json_annotation/json_annotation.dart';
part 'video.g.dart';

@JsonSerializable()
class Video {
  String id;
  String key;
  String site;
  String name;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);  
  Video(
    {this.id,
    this.key,
    this.site,
    this.name});

  @override
  bool operator ==(dynamic other) {
    return other is Video && id == other.id;
  }
  @override
  int get hashCode => super.hashCode;
}