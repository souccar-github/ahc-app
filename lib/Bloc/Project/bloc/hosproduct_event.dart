part of 'hosproduct_bloc.dart';

abstract class HosProductEvent {}

class InitHosProductAdd extends HosProductEvent {}

class InitHosProductUpdate extends HosProductEvent {
  final int id;
  InitHosProductUpdate(this.id);
}

class InitHosProducts extends HosProductEvent {
  final int id;
  InitHosProducts(this.id);
}

class CreateHosProduct extends HosProductEvent {
  final HosProductModel product;
  CreateHosProduct(this.product);
}

class UpdateHosProduct extends HosProductEvent {
  final HosProductModel product;
  UpdateHosProduct(this.product);
}

class DeleteHosProduct extends HosProductEvent {
  final int id;
  DeleteHosProduct(this.id);
}
