// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
    id: json['id'] as String,
    key: json['key'] as String,
    site: json['site'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'site': instance.site,
      'name': instance.name,
    };
