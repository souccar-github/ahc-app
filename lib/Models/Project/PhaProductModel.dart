import 'package:json_annotation/json_annotation.dart';
part 'PhaProductModel.g.dart';

@JsonSerializable()
class PhaProductModel {
  @JsonKey(nullable: true)
  int id;
  @JsonKey(nullable: true)
  int matId;
  @JsonKey(nullable: false)
  bool availability;
  @JsonKey(nullable: false)
  int pharmacyVisitId;
  @JsonKey(nullable: false)
  int productId;
  @JsonKey(nullable: false)
  int sample;
  @JsonKey(nullable: false)
  String productNote;

  PhaProductModel(this.id,this.matId, this.availability, this.pharmacyVisitId,
      this.productId, this.sample, this.productNote);
  factory PhaProductModel.fromJson(Map<String, dynamic> json) =>
      _$PhaProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$PhaProductModelToJson(this);
}
