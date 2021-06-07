import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/MonthModel.dart';

part 'month_event.dart';
part 'month_state.dart';

class MonthBloc extends Bloc<MonthEvent, MonthState> {
  MonthBloc() : super(MonthInitial());

  @override
  Stream<MonthState> mapEventToState(
    MonthEvent event,
  ) async* {
    String error, success;
    List<MonthModel> months;
    if (event is GetMonths) {
      yield MonthsLoading();
      await Project.apiClient.getMonths().then((onValue) {
        months = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (months != null) {
        yield MonthsGetSuccessfully(months);
      } else {
        yield MonthsError(error);
      }
    }
    if (event is AddNewMonth){
      yield MonthsLoading();
      success = null;error = null;
      await Project.apiClient.addMonth(event.month,event.year).then((onValue){
        success = onValue;
      }).catchError((onError){
        error = onError;
      });
      if (error == null){
        yield MonthAddedSuccessfully();
      }else{
        yield MonthsError(error);
      }
    }
    if (event is UpdateMonth){
      yield MonthsLoading();
      success = null;error = null;
      await Project.apiClient.updateMonth(event.id,event.month,event.year).then((onValue){
        success = onValue;
      }).catchError((onError){
        error = onError;
      });
      if (error == null){
        yield MonthAddedSuccessfully();
      }else{
        yield MonthsError(error);
      }
    }
    if (event is DeleteMonth){
      yield MonthsLoading();
      success = null;error = null;
      await Project.apiClient.deleteMonth(event.id).then((onValue){
        success = onValue;
      }).catchError((onError){
        error = onError;
      });
      if (error == null){
        yield MonthDeletedSuccessfully();
      }else{
        yield MonthsError(error);
      }
    }

  }
}
