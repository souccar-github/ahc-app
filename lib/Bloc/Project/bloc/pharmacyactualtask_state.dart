part of 'pharmacyactualtask_bloc.dart';

abstract class PharmacyactualtaskState {}

class PhaActualInitState extends PharmacyactualtaskState {}

class PhaActualError extends PharmacyactualtaskState {
  final String error;
  PhaActualError(this.error);
}

class InitCreatePhaActualSuccessfully extends PharmacyactualtaskState {}

class InitUpdatePhaActualSuccessfully extends PharmacyactualtaskState {
  final ActualModel pha;
  final List<ListItemModel> phList;
  final List<ListItemModel> prList;
  InitUpdatePhaActualSuccessfully(this.pha, this.phList, this.prList);
}

class InitAddPhaActualSuccessfully extends PharmacyactualtaskState {
  final List<ListItemModel> phList;
  final List<ListItemModel> prList;
  InitAddPhaActualSuccessfully(this.phList, this.prList);
}

class PhaActualLoading extends PharmacyactualtaskState {}

class CreatePhaSuccessfully extends PharmacyactualtaskState {
  final bool check;

  CreatePhaSuccessfully(this.check);
}

class UpdatePhaSuccessfully extends PharmacyactualtaskState {
  final bool check;

  UpdatePhaSuccessfully(this.check);
}
