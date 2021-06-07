part of 'pharmacyactualtask_bloc.dart';

abstract class PharmacyactualtaskEvent {}

class InitPhaActualAdd extends PharmacyactualtaskEvent {}

class InitPhaActualUpdate extends PharmacyactualtaskEvent {
  final int id;
  InitPhaActualUpdate(this.id);
}

class InitPhaActualUpdateShort extends PharmacyactualtaskEvent {
  final int id;
  InitPhaActualUpdateShort(this.id);
}

class InitPhaActualAddShort extends PharmacyactualtaskEvent {}

class CreatePhaActual extends PharmacyactualtaskEvent {
  final ActualModel task;
  CreatePhaActual(this.task);
}

class UpdatePhaActual extends PharmacyactualtaskEvent {
  final ActualModel task;
  UpdatePhaActual(this.task);
}
