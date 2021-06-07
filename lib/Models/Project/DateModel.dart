import 'package:json_annotation/json_annotation.dart';
part 'DateModel.g.dart';


@JsonSerializable()
class DateModel {

  @JsonKey(nullable: false)
   String date;


  DateModel(this.date);
factory DateModel.fromJson(Map<String, dynamic> json) => _$DateModelFromJson(json);
  Map<String, dynamic> toJson() => _$DateModelToJson(this);

}