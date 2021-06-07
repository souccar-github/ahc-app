import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/PhaProductModel.dart';

part 'pharmacyactualtask_event.dart';
part 'pharmacyactualtask_state.dart';

class PharmacyactualtaskBloc
    extends Bloc<PharmacyactualtaskEvent, PharmacyactualtaskState> {
  PharmacyactualtaskBloc() : super(PhaActualInitState());

  @override
  Stream<PharmacyactualtaskState> mapEventToState(
    PharmacyactualtaskEvent event,
  ) async* {
    if (event is InitPhaActualAdd) {
      yield PhaActualLoading();
      List<ListItemModel> dr, pr;
      String error = null;
      await Project.apiClient.getPharmacies().then((onValue) {
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
        yield InitAddPhaActualSuccessfully(dr, pr);
      } else {
        yield PhaActualError(error);
      }
    }

    if (event is InitPhaActualUpdateShort) {
      yield PhaActualLoading();
      String error;
      ActualModel task;
      List<ListItemModel> drList, prList;
      await Project.apiClient.getPhaActualTask(event.id).then((onValue) {
        task = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPharmaciesShort().then((onValue) {
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
        yield InitUpdatePhaActualSuccessfully(task, drList, prList);
      } else {
        yield PhaActualError(error);
      }
    }

    if (event is InitPhaActualAddShort) {
      yield PhaActualLoading();
      String error;
      var ph = new List<ListItemModel>();
      var pr = new List<ListItemModel>();
      await Project.apiClient.getPharmaciesShort().then((onValue) {
        ph = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        pr = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddPhaActualSuccessfully(ph, pr);
      } else {
        yield PhaActualError(error);
      }
    }

    if (event is CreatePhaActual) {
      yield PhaActualLoading();
      String success, error = null;
      await Project.apiClient.addActualTask(event.task).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield CreatePhaSuccessfully();
      } else {
        yield PhaActualError(error);
      }
    }

    if (event is UpdatePhaActual) {
      yield PhaActualLoading();
      String success, error = null;
      await Project.apiClient.updateActualTask(event.task).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield UpdatePhaSuccessfully();
      } else {
        yield PhaActualError(error);
      }
    }

    if (event is InitPhaActualUpdate) {
      yield PhaActualLoading();
      String error;
      ActualModel task;
      List<ListItemModel> phList, prList;
      await Project.apiClient.getPhaActualTask(event.id).then((onValue) {
        task = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPharmacies().then((onValue) {
        phList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPeriods().then((onValue) {
        prList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdatePhaActualSuccessfully(task, phList, prList);
      } else {
        yield PhaActualError(error);
      }
    }
  }
}
