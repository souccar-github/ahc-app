import 'package:json_annotation/json_annotation.dart';
part 'ClinicModel.g.dart';

@JsonSerializable()
class ClinicModel {
  @JsonKey(nullable: true)
  int id;
  @JsonKey(nullable: false)
  int clinicId;
  @JsonKey(nullable: false)
  int visitTypeId;
  @JsonKey(nullable: false)
  int hospitalVisitId;

  ClinicModel(this.id, this.clinicId, this.visitTypeId, this.hospitalVisitId);
  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicModelToJson(this);
}
