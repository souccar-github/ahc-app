part of 'planned_bloc.dart';

abstract class PlannedState {
  const PlannedState();
}

class PlannedInitial extends PlannedState {}
class PlannedLoading extends PlannedState {}
class GetPlannedTasksSuccessfully extends PlannedState {
  final List<Event> list;
  GetPlannedTasksSuccessfully(this.list);
}
class GetDayPlannedTasksSuccessfully extends PlannedState {
  final List<ListItemModel> list;
  GetDayPlannedTasksSuccessfully(this.list);
}
class GetPlannedTasksError extends PlannedState {
  final String error;
  GetPlannedTasksError(this.error);
}

class PlannedTaskError extends PlannedState {
  final String error;
  PlannedTaskError(this.error);
}

class InitAddPlannedSuccessfully extends PlannedState{}
class InitUpdatePlannedSuccessfully extends PlannedState{
  final PlanningTaskModel task;
  InitUpdatePlannedSuccessfully(this.task);
}
class AddPlannedSuccessfully extends PlannedState{
  final bool check;

  AddPlannedSuccessfully(this.check);
}
class UpdatePlannedSuccessfully extends PlannedState{
  final bool check;

  UpdatePlannedSuccessfully(this.check);
}
class DeletePlannedSuccessfully extends PlannedState{}

class InitAddPhysicianSuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitAddPhysicianSuccessfully(this.list);
}
class InitAddPharmacySuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitAddPharmacySuccessfully(this.list);
}
class InitAddHospitalSuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitAddHospitalSuccessfully(this.list);
}
class InitAddCoachingSuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitAddCoachingSuccessfully(this.list);
}
class InitAddOtherTaskSuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitAddOtherTaskSuccessfully(this.list);
}
class InitAddVacationSuccessfully extends PlannedState{
}

class InitUpdatePhysicianSuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitUpdatePhysicianSuccessfully(this.list);
}
class InitUpdatePharmacySuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitUpdatePharmacySuccessfully(this.list);
}
class InitUpdateHospitalSuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitUpdateHospitalSuccessfully(this.list);
}
class InitUpdateCoachingSuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitUpdateCoachingSuccessfully(this.list);
}
class InitUpdateOtherTaskSuccessfully extends PlannedState{
  final List<ListItemModel> list;
  InitUpdateOtherTaskSuccessfully(this.list);
}
class InitUpdateVacationSuccessfully extends PlannedState{
}
