part of 'hospitalactualtask_bloc.dart';

abstract class HospitalactualtaskEvent {}

class InitHosActualAdd extends HospitalactualtaskEvent {}

class InitHosActualUpdate extends HospitalactualtaskEvent {
  final int id;
  InitHosActualUpdate(this.id);
}

class InitHosActualUpdateShort extends HospitalactualtaskEvent {
  final int id;
  InitHosActualUpdateShort(this.id);
}

class InitHosActualAddShort extends HospitalactualtaskEvent {}

class CreateHosActual extends HospitalactualtaskEvent {
  final ActualModel task;
  CreateHosActual(this.task);
}

class UpdateHosActual extends HospitalactualtaskEvent {
  final ActualModel task;
  UpdateHosActual(this.task);
}
