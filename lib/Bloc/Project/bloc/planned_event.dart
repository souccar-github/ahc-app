part of 'planned_bloc.dart';

abstract class PlannedEvent {
}

class GetDayTasks extends PlannedEvent{
  final DateTime date;
  final int id;
  GetDayTasks(this.date,this.id);
}

class GetPlannedTasks extends PlannedEvent{
  final int id;
  GetPlannedTasks(this.id);
}

class InitAddPlannedTask extends PlannedEvent{}
class InitUpdatePlannedTask extends PlannedEvent{
  final int id ;
  InitUpdatePlannedTask(this.id);
}

class DeletePlannedTask extends PlannedEvent{
  final int id ;
  DeletePlannedTask(this.id);
}

class AddPlannedTask extends PlannedEvent{}
class UpdatePlannedTask extends PlannedEvent{}

class InitAddPhysician extends PlannedEvent{}
class InitAddPharmacy extends PlannedEvent{}
class InitAddHospital extends PlannedEvent{}
class InitAddCoaching extends PlannedEvent{}
class InitAddOtherTask extends PlannedEvent{}
class InitAddVacation extends PlannedEvent{}

class InitAddPhysicianShort extends PlannedEvent{}
class InitAddPharmacyShort extends PlannedEvent{}
class InitAddHospitalShort extends PlannedEvent{}
class InitAddCoachingShort extends PlannedEvent{}
class InitAddOtherTaskShort extends PlannedEvent{}
class InitAddVacationShort extends PlannedEvent{}

class InitUpdatePhysician extends PlannedEvent{}
class InitUpdatePharmacy extends PlannedEvent{}
class InitUpdateHospital extends PlannedEvent{}
class InitUpdateCoaching extends PlannedEvent{}
class InitUpdateOtherTask extends PlannedEvent{}
class InitUpdateVacation extends PlannedEvent{}

class InitUpdatePhysicianShort extends PlannedEvent{}
class InitUpdatePharmacyShort extends PlannedEvent{}
class InitUpdateHospitalShort extends PlannedEvent{}
class InitUpdateCoachingShort extends PlannedEvent{}
class InitUpdateOtherTaskShort extends PlannedEvent{}
class InitUpdateVacationShort extends PlannedEvent{}

class CreatePlanningTask extends PlannedEvent{
  final PlanningTaskModel task;
  CreatePlanningTask(this.task);
}
class UpdatePlanningTask extends PlannedEvent{
  final PlanningTaskModel task;
  UpdatePlanningTask(this.task);
}



