import 'package:json_annotation/json_annotation.dart';
part 'ActualVisitModel.g.dart';

@JsonSerializable()
class ActualVisitModel {
  @JsonKey(nullable: false)
  String visitType;
  @JsonKey(nullable: true)
  String name;
  @JsonKey(nullable: true)
  String address;
  @JsonKey(nullable: true)
  String rating;
  @JsonKey(nullable: true)
  int numberOfVisit;
  @JsonKey (nullable: true)
  List<DateTime> dates;

  ActualVisitModel(
      this.visitType, this.name, this.address, this.rating, this.numberOfVisit,this.dates);
  factory ActualVisitModel.fromJson(Map<String, dynamic> json) =>
      _$ActualVisitModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActualVisitModelToJson(this);
}
