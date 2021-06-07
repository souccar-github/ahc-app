import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';

part 'otheractualtask_event.dart';
part 'otheractualtask_state.dart';

class OtheractualtaskBloc extends Bloc<OtheractualtaskEvent, OtheractualtaskState> {
  OtheractualtaskBloc() : super(OtheractualtaskInitial());

  @override
  Stream<OtheractualtaskState> mapEventToState(
    OtheractualtaskEvent event,
  ) async* {
    if (event is InitOtherActualAdd) {
      yield OtherActualLoading();
      List<ListItemModel> others;
      String error = null;
      await Project.apiClient.getOtherTask().then((onValue) {
        others = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddOtherActualSuccessfully(others,event.day);
      } else {
        yield OtherActualError(error);
      }
    }
    if (event is CreateOtherActual) {
      String success, error = null;
      bool check = false;
      if (event.task.day > 31 || event.task.day < 1) {
        yield OtherActualError("Day must be between 1-31");
      } else if (event.task.important == true &&
          (event.task.visitNote == "" || event.task.visitNote == null)) {
        yield OtherActualError("Notes field is required");
      } else {
      yield OtherActualLoading();

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
          yield CreateOtherSuccessfully(check);
        } else {
          yield OtherActualError(error);
        }
      }

      if (event is UpdateOtherActual) {
      String success, error = null;
      bool check = false;
      if (event.task.day > 31 || event.task.day < 1) {
        yield OtherActualError("Day must be between 1-31");
      } else if (event.task.important == true &&
          (event.task.visitNote == "" || event.task.visitNote == null)) {
        yield OtherActualError("Notes field is required");
      } else {
        yield OtherActualLoading();
        await Project.apiClient
            .checkHolidayActual(
                event.task.monthId.toString(), event.task.day.toString())
            .then((onValue) {
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
          yield UpdateOtherSuccessfully(check);
        } else {
          yield OtherActualError(error);
        }
      }
    }
    }
    if (event is InitOtherActualUpdate) {
      yield OtherActualLoading();
      String error;
      ActualModel task;
      List<ListItemModel> otherList;
      await Project.apiClient.getOtherActualTask(event.id).then((onValue) {
        task = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getOtherTask().then((onValue) {
        otherList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdateOtherActualSuccessfully(task, otherList,event.day);
      } else {
        yield OtherActualError(error);
      }
    }

    if (event is UpdateOtherActual) {
      String success, error = null;
      bool check = false;
      if (event.task.day > 31 || event.task.day < 1) {
        yield OtherActualError("Day must be between 1-31");
      } else if (event.task.important == true &&
          (event.task.visitNote == "" || event.task.visitNote == null)) {
        yield OtherActualError("Notes field is required");
      } else {
        yield OtherActualLoading();
        await Project.apiClient
            .checkHolidayActual(
                event.task.monthId.toString(), event.task.day.toString())
            .then((onValue) {
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
          yield UpdateOtherSuccessfully(check);
        } else {
          yield OtherActualError(error);
        }
      }
    }
  }
}
