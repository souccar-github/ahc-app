// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlanningTaskModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanningTaskModel _$PlanningTaskModelFromJson(Map<String, dynamic> json) {
  return PlanningTaskModel(
    json['id'] as int,
    json['monthId'] as int,
    json['employeeId'] as int,
    json['hospitalId'] as int,
    json['isShortList'] as bool,
    json['otherTaskTypeId'] as int,
    json['pharmacyId'] as int,
    json['physicianId'] as int,
    json['taskDate'] == null
        ? null
        : DateTime.parse(json['taskDate'] as String),
    json['taskType'] as String,
  );
}

Map<String, dynamic> _$PlanningTaskModelToJson(PlanningTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'monthId': instance.monthId,
      'taskDate': instance.taskDate?.toIso8601String(),
      'taskType': instance.taskType,
      'isShortList': instance.isShortList,
      'physicianId': instance.physicianId,
      'pharmacyId': instance.pharmacyId,
      'hospitalId': instance.hospitalId,
      'employeeId': instance.employeeId,
      'otherTaskTypeId': instance.otherTaskTypeId,
    };
