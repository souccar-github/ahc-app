import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/DateModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/PlanningTaskModel.dart';

part 'planned_event.dart';
part 'planned_state.dart';

class PlannedBloc extends Bloc<PlannedEvent, PlannedState> {
  PlannedBloc() : super(PlannedInitial());

  @override
  Stream<PlannedState> mapEventToState(
    PlannedEvent event,
  ) async* {
    if (event is GetPlannedTasks) {
      yield PlannedLoading();
      var _list = new List<Event>();
      String error = null;
      await Project.apiClient.getPlannedTasks(event.id).then((onValue) {
        for (var i = 0; i < onValue.length; i++) {
          var event = new Event(date: DateTime.parse(onValue[i].date));
          _list.add(event);
        }
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield GetPlannedTasksSuccessfully(_list);
      } else {
        yield GetPlannedTasksError(error);
      }
    }
    if (event is GetDayTasks) {
      yield PlannedLoading();
      var _list = new List<ListItemModel>();
      String error = null;
      await Project.apiClient
          .getDayPlannedTasks(event.id, event.date.day)
          .then((onValue) {
        _list = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield GetDayPlannedTasksSuccessfully(_list);
      } else {
        yield GetPlannedTasksError(error);
      }
    }
    if (event is InitAddPlannedTask) {
      yield PlannedLoading();
      yield InitAddPlannedSuccessfully();
    }
    if (event is InitUpdatePlannedTask) {
      yield PlannedLoading();
      String error;
      PlanningTaskModel task;
      await Project.apiClient.getPlannedTask(event.id).then((onValue) {
        task = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdatePlannedSuccessfully(task);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitAddPhysician) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getPhysicians().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitAddPhysicianSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitAddPharmacy) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getPharmacies().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitAddPharmacySuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitAddHospital) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getHospitals().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitAddHospitalSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitAddCoaching) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getEmployees().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitAddCoachingSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitAddOtherTask) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getOtherTask().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitAddOtherTaskSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitAddVacation) {
      yield InitAddVacationSuccessfully();
    }
    if (event is InitUpdatePhysician) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getPhysicians().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitUpdatePhysicianSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitUpdatePharmacy) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getPharmacies().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitUpdatePharmacySuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitUpdateHospital) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getHospitals().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitUpdateHospitalSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitUpdateCoaching) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getEmployees().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitUpdateCoachingSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitUpdateOtherTask) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getOtherTask().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitUpdateOtherTaskSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitUpdateVacation) {
      yield InitUpdateVacationSuccessfully();
    }
    if (event is InitAddPhysicianShort) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getPhysiciansShort().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitAddPhysicianSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitAddPharmacyShort) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getPharmaciesShort().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitAddPharmacySuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitAddHospitalShort) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getHospitalsShort().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitAddHospitalSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitUpdatePhysicianShort) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getPhysiciansShort().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitUpdatePhysicianSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitUpdatePharmacyShort) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getPharmaciesShort().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitUpdatePharmacySuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is InitUpdateHospitalShort) {
      yield PlannedLoading();
      String error;
      var items = new List<ListItemModel>();
      await Project.apiClient.getHospitalsShort().then((onValue) {
        items = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (items != null) {
        yield InitUpdateHospitalSuccessfully(items);
      } else {
        yield PlannedTaskError(error);
      }
    }
    if (event is CreatePlanningTask) {
      yield PlannedLoading();
      String error, success;
      var task = event.task;
      if (event.task.pharmacyId == null &&
          event.task.physicianId == null &&
          event.task.hospitalId == null &&
          event.task.otherTaskTypeId == null &&
          event.task.employeeId == null &&
          event.task.taskType != "Vacation") {
        error = "All Text Field Are Required";
        yield PlannedTaskError(error);
      } else {
        await Project.apiClient.addPlannedTask(task).then((onValue) {
          success = onValue;
        }).catchError((onError) {
          error = onError;
        });
        if (error == null) {
          yield AddPlannedSuccessfully();
        } else {
          yield PlannedTaskError(error);
        }
      }
    }

    if (event is UpdatePlanningTask) {
      yield PlannedLoading();
      String error, success;
      var task = event.task;
      if (event.task.pharmacyId == null &&
          event.task.physicianId == null &&
          event.task.hospitalId == null &&
          event.task.otherTaskTypeId == null &&
          event.task.employeeId == null &&
          event.task.taskType != "Vacation") {
        error = "All Text Field Are Required";
        yield PlannedTaskError(error);
      } else {
        await Project.apiClient.updatePlannedTask(task).then((onValue) {
          success = onValue;
        }).catchError((onError) {
          error = onError;
        });
        if (error == null) {
          yield UpdatePlannedSuccessfully();
        } else {
          yield PlannedTaskError(error);
        }
      }
    }

    if (event is DeletePlannedTask) {
      yield PlannedLoading();
      String error, success;
      await Project.apiClient.deletePlannedTask(event.id).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield DeletePlannedSuccessfully();
      } else {
        yield PlannedTaskError(error);
      }
    }
  }
}
