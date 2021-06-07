part of 'otheractualtask_bloc.dart';

abstract class OtheractualtaskEvent  {}

class InitOtherActualAdd extends OtheractualtaskEvent {
  final int day;
  InitOtherActualAdd(this.day);
}

class InitOtherActualUpdate extends OtheractualtaskEvent {
  final int id;
  final int day;
  InitOtherActualUpdate(this.id,this.day);
}

class CreateOtherActual extends OtheractualtaskEvent {
  final ActualModel task;
  CreateOtherActual(this.task);
}

class UpdateOtherActual extends OtheractualtaskEvent {
  final ActualModel task;
  UpdateOtherActual(this.task);
}

