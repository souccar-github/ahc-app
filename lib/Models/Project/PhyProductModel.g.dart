// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PhyProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhyProductModel _$PhyProductModelFromJson(Map<String, dynamic> json) {
  return PhyProductModel(
    json['id'] as int,
    json['adoptionId'] as int,
    json['matId'] as int,
    json['complaintId'] as int,
    json['physicianVisitId'] as int,
    json['productId'] as int,
    json['sample'] as int,
    json['productNote'] as String,
  );
}

Map<String, dynamic> _$PhyProductModelToJson(PhyProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adoptionId': instance.adoptionId,
      'matId': instance.matId,
      'complaintId': instance.complaintId,
      'physicianVisitId': instance.physicianVisitId,
      'productId': instance.productId,
      'sample': instance.sample,
      'productNote': instance.productNote,
    };
