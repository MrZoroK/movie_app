import 'package:json_annotation/json_annotation.dart';

import 'review_detail.dart';
part 'review.g.dart';

@JsonSerializable()
class Review {
  String id;
  String author;
  String content;
  
  @JsonKey(ignore: true)
  ReviewDetail detail;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);  
  Review(
    {this.id,
    this.author,
    this.content});
}