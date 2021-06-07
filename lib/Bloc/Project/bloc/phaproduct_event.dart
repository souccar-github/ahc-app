part of 'phaproduct_bloc.dart';

abstract class PhaProductEvent {}

class InitPhaProductAdd extends PhaProductEvent {}

class InitPhaProductUpdate extends PhaProductEvent {
  final int id;
  InitPhaProductUpdate(this.id);
}

class InitPhaProducts extends PhaProductEvent {
  final int id;
  InitPhaProducts(this.id);
}

class CreatePhaProduct extends PhaProductEvent {
  final PhaProductModel product;
  CreatePhaProduct(this.product);
}

class UpdatePhaProduct extends PhaProductEvent {
  final PhaProductModel product;
  UpdatePhaProduct(this.product);
}

class DeletePhaProduct extends PhaProductEvent {
  final int id;
  DeletePhaProduct(this.id);
}
