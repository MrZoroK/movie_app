// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cast _$CastFromJson(Map<String, dynamic> json) {
  return Cast(
    character: json['character'] as String,
    id: json['id'] as int,
    name: json['name'] as String,
    order: json['order'] as int,
    profilePath: json['profile_path'] as String,
  );
}

Map<String, dynamic> _$CastToJson(Cast instance) => <String, dynamic>{
      'character': instance.character,
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'profile_path': instance.profilePath,
    };
