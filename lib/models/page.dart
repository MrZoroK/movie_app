import 'package:json_annotation/json_annotation.dart';
import '../models.dart';
part 'page.g.dart';

@JsonSerializable(explicitToJson: true)
class Page<T> {
  @_Converter()
  @JsonKey(name: "results")
  List<T> items;
  int page;
  @JsonKey(name: "total_results", required: false, defaultValue: 1)
  int totalResults;
  @JsonKey(name: "total_pages", required: false, defaultValue: 1)
  int totalPages;
  bool next() {
    if (page < totalPages - 1) {
      page++;
      return true;
    }
    return false;
  }

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
  Map<String, dynamic> toJson() => _$PageToJson(this);  
  Page(
    {
    this.page,
    this.totalPages,
    this.totalResults,
    this.items});
}

class _Converter<T> implements JsonConverter<T, Object> {
  const _Converter();

  @override
  T fromJson(Object json) {
    if (T == MovieBase) {
      return MovieBase.fromJson(json) as T;
    } else if (T == Review) {
      return Review.fromJson(json) as T;
    }
    throw UnimplementedError();
  }

  @override
  Object toJson(T obj) {
    if (T == MovieBase) {
      return (obj as MovieBase).toJson();
    } else if (T == Review) {
      return (obj as Review).toJson();
    }
    throw UnimplementedError();
  }
}