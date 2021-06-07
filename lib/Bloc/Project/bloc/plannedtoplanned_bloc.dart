import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ListItemModel.dart';

part 'plannedtoplanned_event.dart';
part 'plannedtoplanned_state.dart';

class PlannedtoplannedBloc
    extends Bloc<PlannedtoplannedEvent, PlannedtoplannedState> {
  PlannedtoplannedBloc() : super(InitPlannedToPlannedSuccessfully());

  @override
  Stream<PlannedtoplannedState> mapEventToState(
    PlannedtoplannedEvent event,
  ) async* {
    if (event is InitPlannedToPlanned) {
      yield PlannedToPlannedLoading();
      yield InitPlannedToPlannedSuccessfully();
    }
    if (event is InitTasksPlannedToPlanned) {
      yield PlannedToPlannedLoading();
      String error;
      List<ListItemModel> tasks;
      var items = new List<ListItemModel>();
      await Project.apiClient
          .getPlannedToPlannedServiceTasks(event.fromDate, event.toDate)
          .then((onValue) {
        tasks = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (tasks != null) {
        yield InitTasksPlannedToPlannedSuccessfully(tasks);
      } else {
        yield PlannedToPlannedError(error);
      }
    }
    if (event is PlannedToPlannedSubmit) {
      yield PlannedToPlannedLoading();
      String error = null, success;
      var items = new List<ListItemModel>();
      await Project.apiClient
          .copyPlannedToPlannedService(event.tasks,event.toDate)
          .then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield PlannedToPlannedSubmittedSuccessfully();
      } else {
        yield PlannedToPlannedError(error);
      }
    }
  }
}
