import 'package:json_annotation/json_annotation.dart';
import '../models.dart';
part 'page.g.dart';

@JsonSerializable(explicitToJson: true)
class PageOf<T> {
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

  factory PageOf.fromJson(Map<String, dynamic> json) => _$PageOfFromJson(json);
  factory PageOf.fromList(List<T> list) {
     return PageOf<T>(
      page: 1,
      totalPages: 1,
      totalResults: list.length,
      items: list,
    );
  }
  Map<String, dynamic> toJson() => _$PageOfToJson(this);  
  PageOf(
    {
    this.page,
    this.totalPages,
    this.totalResults,
    this.items});

  void append(PageOf<T> nextPage) {
    //TODO: should merge instead of append
    if (this.page < nextPage.page) {
      this.items.addAll(nextPage.items);
      this.page = nextPage.page;
    }
  }
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