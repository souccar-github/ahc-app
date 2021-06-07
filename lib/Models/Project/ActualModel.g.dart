// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActualModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActualModel _$ActualModelFromJson(Map<String, dynamic> json) {
  return ActualModel(
    json['id'] as int,
    json['monthId'] as int,
    json['hospitalId'] as int,
    json['isShortList'] as bool,
    json['pharmacyId'] as int,
    json['physicianId'] as int,
    json['day'] as int,
    json['important'] as bool,
    json['visitNote'] as String,
    json['periodId'] as int,
    json['otherId'] as int,
  );
}

Map<String, dynamic> _$ActualModelToJson(ActualModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'monthId': instance.monthId,
      'day': instance.day,
      'isShortList': instance.isShortList,
      'important': instance.important,
      'visitNote': instance.visitNote,
      'periodId': instance.periodId,
      'pharmacyId': instance.pharmacyId,
      'hospitalId': instance.hospitalId,
      'physicianId': instance.physicianId,
      'otherId': instance.otherId,
    };
