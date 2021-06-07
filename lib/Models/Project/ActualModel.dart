import 'package:json_annotation/json_annotation.dart';
part 'ActualModel.g.dart';


@JsonSerializable()
class ActualModel {

  @JsonKey(nullable: true)
   int id;
   @JsonKey(nullable: false)
   int monthId;
   @JsonKey(nullable: false)
   int day;
   @JsonKey(nullable: false)
   bool isShortList; 
   @JsonKey(nullable: false)
   bool important;
   @JsonKey(nullable: true)
   String visitNote;
   @JsonKey(nullable: true)
   int periodId;
   @JsonKey(nullable: true)
   int pharmacyId;
   @JsonKey(nullable: true)
   int hospitalId;
   @JsonKey(nullable: true)
   int physicianId;
@JsonKey(nullable: true)
   int otherId;


  ActualModel(this.id,this.monthId,this.hospitalId,this.isShortList,this.pharmacyId,this.physicianId,this.day,this.important,this.visitNote,this.periodId,this.otherId);
factory ActualModel.fromJson(Map<String, dynamic> json) => _$ActualModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActualModelToJson(this);

}