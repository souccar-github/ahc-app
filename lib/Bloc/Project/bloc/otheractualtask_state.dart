part of 'otheractualtask_bloc.dart';

abstract class OtheractualtaskState {}

class OtheractualtaskInitial extends OtheractualtaskState {}

class OtherActualError extends OtheractualtaskState {
  final String error;
  OtherActualError(this.error);
}

class InitAddOtherActualSuccessfully extends OtheractualtaskState {
  final List<ListItemModel> otherList;
  final int day;
  InitAddOtherActualSuccessfully(this.otherList,this.day);
}

class InitUpdateOtherActualSuccessfully extends OtheractualtaskState {
  final ActualModel other;
  final List<ListItemModel> otherList;
  final int day;
  InitUpdateOtherActualSuccessfully(this.other, this.otherList,this.day);
}

class CreateOtherSuccessfully extends OtheractualtaskState {
  final bool check;
  CreateOtherSuccessfully(this.check);
}

class UpdateOtherSuccessfully extends OtheractualtaskState {
  final bool check;
  UpdateOtherSuccessfully(this.check);
}

class OtherActualLoading extends OtheractualtaskState {}


