import 'package:json_annotation/json_annotation.dart';
part 'MonthModel.g.dart';


@JsonSerializable()
class MonthModel {

  @JsonKey(nullable: false)
   int Year;
  @JsonKey(nullable: false)
   int MonthNumber;
  @JsonKey(nullable: false)
   String NameForDropdown;
    @JsonKey(nullable: false)
   int Id;


  MonthModel(this.NameForDropdown,this.Year,this.MonthNumber,this.Id);
factory MonthModel.fromJson(Map<String, dynamic> json) => _$MonthModelFromJson(json);
  Map<String, dynamic> toJson() => _$MonthModelToJson(this);

}