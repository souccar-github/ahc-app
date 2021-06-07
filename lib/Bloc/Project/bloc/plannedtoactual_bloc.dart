import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ListItemModel.dart';

part 'plannedtoactual_event.dart';
part 'plannedtoactual_state.dart';

class PlannedtoactualBloc
    extends Bloc<PlannedtoactualEvent, PlannedtoactualState> {
  PlannedtoactualBloc() : super(InitPlannedToActualSuccessfully());

  @override
  Stream<PlannedtoactualState> mapEventToState(
    PlannedtoactualEvent event,
  ) async* {
    if (event is InitPlannedToActual) {
      yield InitPlannedToActualSuccessfully();
    }
    if (event is InitTasksPlannedToActual) {
      yield PlannedToActualLoading();
      String error;
      List<ListItemModel> tasks;
      var items = new List<ListItemModel>();
      await Project.apiClient
          .getPlannedToActualServiceTasks(event.date)
          .then((onValue) {
        tasks = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (tasks != null) {
        yield InitTasksPlannedToActualSuccessfully(tasks);
      } else {
        yield PlannedToActualError(error);
      }
      
    }
    if (event is PlannedToActualSubmit) {
      if (DateTime.parse(event.date).isAfter(DateTime.now())){
        yield PlannedToActualError("يجب اختيار تاريخ أصغر من التاريخ الحالي");
      }
        yield PlannedToActualLoading();
        String error = null,success;
        var items = new List<ListItemModel>();
        await Project.apiClient
            .copyPlannedToActualService(event.tasks)
            .then((onValue) {
          success = onValue;
        }).catchError((onError) {
          error = onError;
        });
        if (error == null) {
          yield PlannedToActualSubmittedSuccessfully();
        } else {
          yield PlannedToActualError(error);
        }
      }
  }
}
