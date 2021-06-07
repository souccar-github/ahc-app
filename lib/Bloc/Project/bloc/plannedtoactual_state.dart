part of 'plannedtoactual_bloc.dart';

abstract class PlannedtoactualState {}

class InitPlannedToActualSuccessfully extends PlannedtoactualState {}

class InitTasksPlannedToActualSuccessfully extends PlannedtoactualState {
  final List<ListItemModel> tasks;
  InitTasksPlannedToActualSuccessfully(this.tasks);
}

class PlannedToActualSubmittedSuccessfully extends PlannedtoactualState {}

class PlannedToActualError extends PlannedtoactualState {
  final String error;
  PlannedToActualError(this.error);
}

class PlannedToActualLoading extends PlannedtoactualState {}
