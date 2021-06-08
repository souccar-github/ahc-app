part of 'physicianactualtask_bloc.dart';

abstract class PhysicianactualtaskState {}

class PhyActualInitState extends PhysicianactualtaskState {}

class PhyActualError extends PhysicianactualtaskState {
  final String error;
  PhyActualError(this.error);
}

class InitCreatePhyActualSuccessfully extends PhysicianactualtaskState {}

class InitUpdatePhyActualSuccessfully extends PhysicianactualtaskState {
  final ActualModel phy;
  final List<ListItemModel> drList;
  final List<ListItemModel> prList;
  InitUpdatePhyActualSuccessfully(this.phy, this.drList, this.prList);
}

class InitAddPhyActualSuccessfully extends PhysicianactualtaskState {
  final List<ListItemModel> drList;
  final List<ListItemModel> prList;
  InitAddPhyActualSuccessfully(this.drList, this.prList);
}

class PhyActualLoading extends PhysicianactualtaskState {}

class CreatePhySuccessfully extends PhysicianactualtaskState {
  final bool check;

  CreatePhySuccessfully(this.check);
}

class UpdatePhySuccessfully extends PhysicianactualtaskState {
  final bool check;

  UpdatePhySuccessfully(this.check);
}
