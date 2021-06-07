part of 'plannedtoactual_bloc.dart';

abstract class PlannedtoactualEvent {}

class InitPlannedToActual extends PlannedtoactualEvent {}

class InitTasksPlannedToActual extends PlannedtoactualEvent {
  final String date;
  InitTasksPlannedToActual(this.date);
}

class PlannedToActualSubmit extends PlannedtoactualEvent {
  final String date;
  final List<String> tasks;
  PlannedToActualSubmit(this.tasks,this.date);
}
