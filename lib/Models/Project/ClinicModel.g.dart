// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClinicModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicModel _$ClinicModelFromJson(Map<String, dynamic> json) {
  return ClinicModel(
    json['id'] as int,
    json['clinicId'] as int,
    json['visitTypeId'] as int,
    json['hospitalVisitId'] as int,
  );
}

Map<String, dynamic> _$ClinicModelToJson(ClinicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinicId': instance.clinicId,
      'visitTypeId': instance.visitTypeId,
      'hospitalVisitId': instance.hospitalVisitId,
    };
