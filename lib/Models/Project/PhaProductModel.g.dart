// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PhaProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhaProductModel _$PhaProductModelFromJson(Map<String, dynamic> json) {
  return PhaProductModel(
    json['id'] as int,
    json['matId'] as int,
    json['availability'] as bool,
    json['pharmacyVisitId'] as int,
    json['productId'] as int,
    json['sample'] as int,
    json['productNote'] as String,
  );
}

Map<String, dynamic> _$PhaProductModelToJson(PhaProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matId': instance.matId,
      'availability': instance.availability,
      'pharmacyVisitId': instance.pharmacyVisitId,
      'productId': instance.productId,
      'sample': instance.sample,
      'productNote': instance.productNote,
    };
