// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageOf<T> _$PageOfFromJson<T>(Map<String, dynamic> json) {
  return PageOf<T>(
    page: json['page'] as int,
    totalPages: json['total_pages'] as int ?? 1,
    totalResults: json['total_results'] as int ?? 1,
    items: (json['results'] as List)?.map(_Converter<T>().fromJson)?.toList(),
  );
}

Map<String, dynamic> _$PageOfToJson<T>(PageOf<T> instance) => <String, dynamic>{
      'results': instance.items?.map(_Converter<T>().toJson)?.toList(),
      'page': instance.page,
      'total_results': instance.totalResults,
      'total_pages': instance.totalPages,
    };
