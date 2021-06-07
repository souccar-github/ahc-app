part of 'physicianproduct_bloc.dart';

abstract class PhysicianProductState {}

class PhysicianProductInitState extends PhysicianProductState {}

class PhysicianProductError extends PhysicianProductState {
  final String error;
  PhysicianProductError(this.error);
}

class InitCreatePhysicianProductSuccessfully extends PhysicianProductState {}

class InitUpdatePhysicianProductSuccessfully extends PhysicianProductState {
  final List<ListItemModel> proList;
  final List<ListItemModel> adoptionList;
  final List<ListItemModel> complaintList;
  final PhyProductModel product;
  final List<ListItemModel> matList;

  InitUpdatePhysicianProductSuccessfully(
      this.proList, this.adoptionList, this.complaintList, this.product,this.matList);
}

class InitAddPhysicianProductSuccessfully extends PhysicianProductState {
  final List<ListItemModel> proList;
  final List<ListItemModel> adList;
  final List<ListItemModel> comList;
  final List<ListItemModel> matList;
  InitAddPhysicianProductSuccessfully(this.proList, this.adList, this.comList,this.matList);
}

class InitUpdatePhysicianSuccessfully extends PhysicianProductState {}

class DeletePhyProductSuccessfully extends PhysicianProductState {}

class PhysicianProductLoading extends PhysicianProductState {}

class CreatePhysicianProductSuccessfully extends PhysicianProductState {}

class UpdatePhyProductSuccessfully extends PhysicianProductState {}

class InitPhysicianProductsSuccessfully extends PhysicianProductState {
  final List<ListItemModel> products;
  InitPhysicianProductsSuccessfully(this.products);
}
