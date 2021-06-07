part of 'physicianactualtask_bloc.dart';

abstract class PhysicianactualtaskEvent {}

class InitPhyActualAdd extends PhysicianactualtaskEvent {}

class InitPhyActualUpdate extends PhysicianactualtaskEvent {
  final int id;
  InitPhyActualUpdate(this.id);
}

class InitPhyActualAddShort extends PhysicianactualtaskEvent {}

class InitPhyActualUpdateShort extends PhysicianactualtaskEvent {
  final int id;
  InitPhyActualUpdateShort(this.id);
}

class CreatePhyActual extends PhysicianactualtaskEvent {
  final ActualModel task;
  CreatePhyActual(this.task);
}

class UpdatePhyActual extends PhysicianactualtaskEvent {
  final ActualModel task;
  UpdatePhyActual(this.task);
}
