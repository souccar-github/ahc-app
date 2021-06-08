import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';

part 'physicianactualtask_event.dart';
part 'physicianactualtask_state.dart';

class PhysicianactualtaskBloc
    extends Bloc<PhysicianactualtaskEvent, PhysicianactualtaskState> {
  PhysicianactualtaskBloc() : super(PhyActualInitState());

  @override
  Stream<PhysicianactualtaskState> mapEventToState(
    PhysicianactualtaskEvent event,
  ) async* {
    if (event is InitPhyActualAdd) {
      yield PhyActualLoading();
      List<ListItemModel> dr, pr;
      String error = null;
      await Project.apiClient.getPhysicians().then((onValue) {
        dr = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        pr = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddPhyActualSuccessfully(dr, pr);
      } else {
        yield PhyActualError(error);
      }
    }

    if (event is InitPhyActualAddShort) {
      yield PhyActualLoading();
      String error;
      var dr = new List<ListItemModel>();
      var pr = new List<ListItemModel>();
      await Project.apiClient.getPhysiciansShort().then((onValue) {
        dr = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        pr = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddPhyActualSuccessfully(dr, pr);
      } else {
        yield PhyActualError(error);
      }
    }

    if (event is InitPhyActualUpdateShort) {
      yield PhyActualLoading();
      String error;
      ActualModel task;
      List<ListItemModel> drList, prList;
      await Project.apiClient.getPhyActualTask(event.id).then((onValue) {
        task = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPhysiciansShort().then((onValue) {
        drList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        prList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdatePhyActualSuccessfully(task, drList, prList);
      } else {
        yield PhyActualError(error);
      }
    }

    if (event is CreatePhyActual) {
      yield PhyActualLoading();
      String success, error = null;
      bool check;
await Project.apiClient.checkHolidayActual(event.task.monthId.toString(),event.task.day.toString()).then((onValue) {
          check = onValue;
        }).catchError((onError) {
          error = onError;
        });
        await Project.apiClient.addActualTask(event.task).then((onValue) {
          success = onValue;
        }).catchError((onError) {
          error = onError;
        });

        if (error == null) {
          yield CreatePhySuccessfully(check);
        } else {
          yield PhyActualError(error);
        }
      
    }

    if (event is UpdatePhyActual) {
      yield PhyActualLoading();
      String success, error = null;
      bool check;
      await Project.apiClient.checkHolidayActual(event.task.monthId.toString(),event.task.day.toString()).then((onValue) {
          check = onValue;
        }).catchError((onError) {
          error = onError;
        });
      await Project.apiClient.updateActualTask(event.task).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield UpdatePhySuccessfully(check);
      } else {
        yield PhyActualError(error);
      }
    }

    if (event is InitPhyActualUpdate) {
      yield PhyActualLoading();
      String error;
      ActualModel task;
      List<ListItemModel> drList, prList;
      await Project.apiClient.getPhyActualTask(event.id).then((onValue) {
        task = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPhysicians().then((onValue) {
        drList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        prList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdatePhyActualSuccessfully(task, drList, prList);
      } else {
        yield PhyActualError(error);
      }
    }
  }
}
