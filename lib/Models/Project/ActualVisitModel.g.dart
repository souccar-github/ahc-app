// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActualVisitModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActualVisitModel _$ActualVisitModelFromJson(Map<String, dynamic> json) {
  return ActualVisitModel(
    json['visitType'] as String,
    json['name'] as String,
    json['address'] as String,
    json['rating'] as String,
    json['numberOfVisit'] as int,
    (json['dates'] as List)
        ?.map((e) => e == null ? null : DateTime.parse(e as String))
        ?.toList(),
  );
}

Map<String, dynamic> _$ActualVisitModelToJson(ActualVisitModel instance) =>
    <String, dynamic>{
      'visitType': instance.visitType,
      'name': instance.name,
      'address': instance.address,
      'rating': instance.rating,
      'numberOfVisit': instance.numberOfVisit,
      'dates': instance.dates?.map((e) => e?.toIso8601String())?.toList(),
    };
