// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MonthModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthModel _$MonthModelFromJson(Map<String, dynamic> json) {
  return MonthModel(
    json['NameForDropdown'] as String,
    json['Year'] as int,
    json['MonthNumber'] as int,
    json['Id'] as int,
  );
}

Map<String, dynamic> _$MonthModelToJson(MonthModel instance) =>
    <String, dynamic>{
      'Year': instance.Year,
      'MonthNumber': instance.MonthNumber,
      'NameForDropdown': instance.NameForDropdown,
      'Id': instance.Id,
    };
