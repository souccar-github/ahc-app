import 'package:json_annotation/json_annotation.dart';
part 'ListItemModel.g.dart';

@JsonSerializable()
class ListItemModel {
  @JsonKey(nullable: false)
  int id;
  @JsonKey(nullable: true)
  String title;
  @JsonKey(nullable: true)
  String body;
  @JsonKey(nullable: true)
  String type;

  ListItemModel(this.id, this.body, this.title, this.type);
  factory ListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ListItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListItemModelToJson(this);
}
