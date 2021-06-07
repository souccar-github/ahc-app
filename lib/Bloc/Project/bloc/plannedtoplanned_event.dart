part of 'plannedtoplanned_bloc.dart';

abstract class PlannedtoplannedEvent {}

class InitPlannedToPlanned extends PlannedtoplannedEvent {}

class InitTasksPlannedToPlanned extends PlannedtoplannedEvent {
  final String fromDate;
  final String toDate;
  InitTasksPlannedToPlanned(this.fromDate,this.toDate);
}

class PlannedToPlannedSubmit extends PlannedtoplannedEvent {
  final List<String> tasks;
  final String toDate;
  PlannedToPlannedSubmit(this.tasks,this.toDate);
}
