// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListItemModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItemModel _$ListItemModelFromJson(Map<String, dynamic> json) {
  return ListItemModel(
    json['id'] as int,
    json['body'] as String,
    json['title'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$ListItemModelToJson(ListItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': instance.type,
    };
