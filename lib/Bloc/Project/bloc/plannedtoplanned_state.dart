part of 'plannedtoplanned_bloc.dart';

abstract class PlannedtoplannedState {}

class InitPlannedToPlannedSuccessfully extends PlannedtoplannedState {}

class InitTasksPlannedToPlannedSuccessfully extends PlannedtoplannedState {
  final List<ListItemModel> tasks;
  InitTasksPlannedToPlannedSuccessfully(this.tasks);
}

class PlannedToPlannedSubmittedSuccessfully extends PlannedtoplannedState {}

class PlannedToPlannedError extends PlannedtoplannedState {
  final String error;
  PlannedToPlannedError(this.error);
}

class PlannedToPlannedLoading extends PlannedtoplannedState {}
