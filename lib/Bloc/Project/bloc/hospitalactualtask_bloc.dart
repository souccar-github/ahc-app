import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';

part 'hospitalactualtask_event.dart';
part 'hospitalactualtask_state.dart';

class HospitalactualtaskBloc
    extends Bloc<HospitalactualtaskEvent, HospitalactualtaskState> {
  HospitalactualtaskBloc() : super(HosActualInitState());

  @override
  Stream<HospitalactualtaskState> mapEventToState(
    HospitalactualtaskEvent event,
  ) async* {
    if (event is InitHosActualAdd) {
      yield HosActualLoading();
      List<ListItemModel> ho, pr;
      String error = null;
      await Project.apiClient.getHospitals().then((onValue) {
        ho = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        pr = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddHosActualSuccessfully(ho, pr);
      } else {
        yield HosActualError(error);
      }
    }

    if (event is InitHosActualAddShort) {
      yield HosActualLoading();
      String error;
      var hos = new List<ListItemModel>();
      var pr = new List<ListItemModel>();
      await Project.apiClient.getHospitalsShort().then((onValue) {
        hos = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        pr = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddHosActualSuccessfully(hos, pr);
      } else {
        yield HosActualError(error);
      }
    }

    if (event is CreateHosActual) {
      yield HosActualLoading();
      String success, error = null;
      await Project.apiClient.addActualTask(event.task).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield CreateHosSuccessfully();
      } else {
        yield HosActualError(error);
      }
    }

    if (event is InitHosActualUpdateShort) {
      yield HosActualLoading();
      String error;
      ActualModel task;
      List<ListItemModel> drList, prList;
      await Project.apiClient.getHosActualTask(event.id).then((onValue) {
        task = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getHospitalsShort().then((onValue) {
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
        yield InitUpdateHosActualSuccessfully(task, drList, prList);
      } else {
        yield HosActualError(error);
      }
    }

    if (event is UpdateHosActual) {
      yield HosActualLoading();
      String success, error = null;
      await Project.apiClient.updateActualTask(event.task).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield UpdateHosSuccessfully();
      } else {
        yield HosActualError(error);
      }
    }

    if (event is InitHosActualUpdate) {
      yield HosActualLoading();
      String error;
      ActualModel task;
      List<ListItemModel> hosList, prList;
      await Project.apiClient.getHosActualTask(event.id).then((onValue) {
        task = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getHospitals().then((onValue) {
        hosList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        prList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdateHosActualSuccessfully(task, hosList, prList);
      } else {
        yield HosActualError(error);
      }
    }
  }
}
