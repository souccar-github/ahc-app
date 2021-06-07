// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HosProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HosProductModel _$HosProductModelFromJson(Map<String, dynamic> json) {
  return HosProductModel(
    json['id'] as int,
    json['adoptionId'] as int,
    json['matId'] as int,
    json['complaintId'] as int,
    json['hospitalClinicVisitId'] as int,
    json['productId'] as int,
    json['sample'] as int,
    json['productNote'] as String,
  );
}

Map<String, dynamic> _$HosProductModelToJson(HosProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matId': instance.matId,
      'adoptionId': instance.adoptionId,
      'complaintId': instance.complaintId,
      'hospitalClinicVisitId': instance.hospitalClinicVisitId,
      'productId': instance.productId,
      'sample': instance.sample,
      'productNote': instance.productNote,
    };
