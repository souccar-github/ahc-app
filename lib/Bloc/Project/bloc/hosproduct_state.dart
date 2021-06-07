part of 'hosproduct_bloc.dart';

abstract class HosProductState {}

class HosProductInitState extends HosProductState {}

class HosProductError extends HosProductState {
  final String error;
  HosProductError(this.error);
}

class InitCreateHosProductSuccessfully extends HosProductState {}

class InitUpdateHosProductSuccessfully extends HosProductState {
  final List<ListItemModel> proList;
  final List<ListItemModel> adoptionList;
  final List<ListItemModel> complaintList;
  final List<ListItemModel> matList;
  final HosProductModel product;
  InitUpdateHosProductSuccessfully(
      this.proList, this.adoptionList,this.matList, this.complaintList, this.product);
}

class InitAddHosProductSuccessfully extends HosProductState {
  final List<ListItemModel> proList;
  final List<ListItemModel> adoptionList;
  final List<ListItemModel> complaintList;
  final List<ListItemModel> matList;
  InitAddHosProductSuccessfully(
      this.proList, this.adoptionList,this.matList, this.complaintList);
}

class InitUpdateHosSuccessfully extends HosProductState {}

class DeleteHosProductSuccessfully extends HosProductState {}

class HosProductLoading extends HosProductState {}

class CreateHosProductSuccessfully extends HosProductState {}

class UpdateHosProductSuccessfully extends HosProductState {}

class InitHosProductsSuccessfully extends HosProductState {
  final List<ListItemModel> products;
  InitHosProductsSuccessfully(this.products);
}
