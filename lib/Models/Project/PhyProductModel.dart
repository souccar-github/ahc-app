import 'package:json_annotation/json_annotation.dart';
part 'PhyProductModel.g.dart';

@JsonSerializable()
class PhyProductModel {
  @JsonKey(nullable: true)
  int id;
  @JsonKey(nullable: false)
  int adoptionId;
  @JsonKey(nullable: true)
  int matId;
  @JsonKey(nullable: true)
  int complaintId;
  @JsonKey(nullable: false)
  int physicianVisitId;
  @JsonKey(nullable: false)
  int productId;
  @JsonKey(nullable: false)
  int sample;
  @JsonKey(nullable: false)
  String productNote;

  PhyProductModel(this.id, this.adoptionId,this.matId, this.complaintId,
      this.physicianVisitId, this.productId, this.sample, this.productNote);
  factory PhyProductModel.fromJson(Map<String, dynamic> json) =>
      _$PhyProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$PhyProductModelToJson(this);
}
