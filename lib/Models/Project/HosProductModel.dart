import 'package:json_annotation/json_annotation.dart';
part 'HosProductModel.g.dart';

@JsonSerializable()
class HosProductModel {
  @JsonKey(nullable: true)
  int id;
  @JsonKey(nullable: true)
  int matId;
  @JsonKey(nullable: false)
  int adoptionId;
  @JsonKey(nullable: true)
  int complaintId;
  @JsonKey(nullable: false)
  int hospitalClinicVisitId;
  @JsonKey(nullable: false)
  int productId;
  @JsonKey(nullable: false)
  int sample;
  @JsonKey(nullable: false)
  String productNote;

  HosProductModel(
      this.id,
      this.adoptionId,
      this.matId,
      this.complaintId,
      this.hospitalClinicVisitId,
      this.productId,
      this.sample,
      this.productNote);
  factory HosProductModel.fromJson(Map<String, dynamic> json) =>
      _$HosProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$HosProductModelToJson(this);
}
