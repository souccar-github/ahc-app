import 'package:json_annotation/json_annotation.dart';
part 'PlanningTaskModel.g.dart';


@JsonSerializable()
class PlanningTaskModel {

  @JsonKey(nullable: true)
   int id;
   @JsonKey(nullable: false)
   int monthId;
   @JsonKey(nullable: true)
   DateTime taskDate;
   @JsonKey(nullable: true)
   String taskType;
   @JsonKey(nullable: false)
   bool isShortList;
   @JsonKey(nullable: true)
   int physicianId;
   @JsonKey(nullable: true)
   int pharmacyId;
   @JsonKey(nullable: true)
   int hospitalId;
   @JsonKey(nullable: true)
   int employeeId;
   @JsonKey(nullable: true)
   int otherTaskTypeId;



  PlanningTaskModel(this.id,this.monthId,this.employeeId,this.hospitalId,this.isShortList,this.otherTaskTypeId,this.pharmacyId,this.physicianId,this.taskDate,this.taskType);
factory PlanningTaskModel.fromJson(Map<String, dynamic> json) => _$PlanningTaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlanningTaskModelToJson(this);

}