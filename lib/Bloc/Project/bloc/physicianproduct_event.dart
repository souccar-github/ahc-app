part of 'physicianproduct_bloc.dart';

abstract class PhysicianProductEvent {}

class InitPhysicianProductAdd extends PhysicianProductEvent {}

class InitPhyProductUpdate extends PhysicianProductEvent {
  final int id;
  InitPhyProductUpdate(this.id);
}

class InitPhysicianProducts extends PhysicianProductEvent {
  final int id;
  InitPhysicianProducts(this.id);
}

class CreatePhysicianProduct extends PhysicianProductEvent {
  final PhyProductModel product;
  CreatePhysicianProduct(this.product);
}

class UpdatePhyProduct extends PhysicianProductEvent {
  final PhyProductModel product;
  UpdatePhyProduct(this.product);
}

class DeletePhyProduct extends PhysicianProductEvent {
  final int id;
  DeletePhyProduct(this.id);
}
