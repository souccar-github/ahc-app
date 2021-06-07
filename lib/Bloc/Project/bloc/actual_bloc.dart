import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';

part 'actual_event.dart';
part 'actual_state.dart';

class ActualBloc extends Bloc<ActualEvent, ActualState> {
  ActualBloc() : super(ActualInitial());

  @override
  Stream<ActualState> mapEventToState(
    ActualEvent event,
  ) async* {
    if (event is GetActualTasks) {
      yield ActualLoading();
      var _list = new List<Event>();
      String error = null;
      await Project.apiClient.getActualTasks(event.id).then((onValue) {
        for (var i = 0; i < onValue.length; i++) {
          var event = new Event(date: DateTime.parse(onValue[i].date));
          _list.add(event);
        }
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield GetActualTasksSuccessfully(_list);
      } else {
        yield GetActualTasksError(error);
      }
    }
    if (event is GetDayTasks) {
      yield ActualLoading();
      var _list = new List<ListItemModel>();
      String error = null;
      await Project.apiClient
          .getDayActualTasks(event.id, event.date.day)
          .then((onValue) {
        _list = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield GetDayActualTasksSuccessfully(_list);
      } else {
        yield GetActualTasksError(error);
      }
    }

    if (event is DeleteActualTask) {
      yield ActualLoading();
      String error = null, success = null;
      switch (event.type) {
        case "PhysicianVisit":
          await Project.apiClient.deletePhyActualTask(event.id).then((onValue) {
            success = onValue;
          }).catchError((onError) {
            error = onError;
          });
          break;
        case "PharmacyVisit":
          await Project.apiClient.deletePhaActualTask(event.id).then((onValue) {
            success = onValue;
          }).catchError((onError) {
            error = onError;
          });
          break;
        case "HospitalVisit":
          await Project.apiClient.deleteHosActualTask(event.id).then((onValue) {
            success = onValue;
          }).catchError((onError) {
            error = onError;
          });
          break;
      }
      if (error == null) {
        yield DeleteActualSuccessfully();
      } else {
        yield ActualTaskError(error);
      }
    }
  }
}
