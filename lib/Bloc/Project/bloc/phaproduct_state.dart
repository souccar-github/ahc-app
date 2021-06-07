part of 'phaproduct_bloc.dart';

abstract class PhaProductState {}

class PhaProductInitState extends PhaProductState {}

class PhaProductError extends PhaProductState {
  final String error;
  PhaProductError(this.error);
}

class InitCreatePhaProductSuccessfully extends PhaProductState {}

class InitUpdatePhaProductSuccessfully extends PhaProductState {
  final PhaProductModel product;
  final List<ListItemModel> proList;
  final List<ListItemModel> matList;

  InitUpdatePhaProductSuccessfully(this.proList, this.product,this.matList);
}

class DeletePhaProductSuccessfully extends PhaProductState {}

class InitAddPhaProductSuccessfully extends PhaProductState {
  final List<ListItemModel> proList;
  final List<ListItemModel> matList;

  InitAddPhaProductSuccessfully(this.proList,this.matList);
}

class InitUpdatePhaSuccessfully extends PhaProductState {}

class PhaProductLoading extends PhaProductState {}

class CreatePhaProductSuccessfully extends PhaProductState {}

class UpdatePhaProductSuccessfully extends PhaProductState {}

class InitPhaProductsSuccessfully extends PhaProductState {
  final List<ListItemModel> products;
  InitPhaProductsSuccessfully(this.products);
}
