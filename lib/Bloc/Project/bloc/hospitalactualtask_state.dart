part of 'hospitalactualtask_bloc.dart';

abstract class HospitalactualtaskState {}

class HosActualInitState extends HospitalactualtaskState {}

class HosActualError extends HospitalactualtaskState {
  final String error;
  HosActualError(this.error);
}

class InitCreateHosActualSuccessfully extends HospitalactualtaskState {}

class InitUpdateHosActualSuccessfully extends HospitalactualtaskState {
  final ActualModel hos;
  final List<ListItemModel> hosList;
  final List<ListItemModel> prList;
  InitUpdateHosActualSuccessfully(this.hos, this.hosList, this.prList);
}

class InitAddHosActualSuccessfully extends HospitalactualtaskState {
  final List<ListItemModel> hoList;
  final List<ListItemModel> prList;
  InitAddHosActualSuccessfully(this.hoList, this.prList);
}

class InitUpdateHosSuccessfully extends HospitalactualtaskState {}

class HosActualLoading extends HospitalactualtaskState {}

class CreateHosSuccessfully extends HospitalactualtaskState {
  final bool check;

  CreateHosSuccessfully(this.check);
}

class UpdateHosSuccessfully extends HospitalactualtaskState {
  final bool check;

  UpdateHosSuccessfully(this.check);
}
