import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ActualVisitModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial());

  @override
  Stream<ReportState> mapEventToState(
    ReportEvent event,
  ) async* {
    if (event is GetHospitalsReport) {
      List<ActualVisitModel> report;
      String error;
      yield ReportLoading();
      await Project.apiClient.getHospitalReport(event.id).then((onValue) {
        report = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield HospitalsReportSuccessfully(report);
      } else {
        yield ReportError(error);
      }
    }
    if (event is GetPhysiciansReport) {
      List<ActualVisitModel> report;
      String error;
      yield ReportLoading();
      await Project.apiClient.getPhysicianReport(event.id).then((onValue) {
        report = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield PhysiciansReportSuccessfully(report);
      } else {
        yield ReportError(error);
      }
    }
    if (event is GetPharmaciesReport) {
      List<ActualVisitModel> report;
      String error;
      yield ReportLoading();
      await Project.apiClient.getPharmacyReport(event.id).then((onValue) {
        report = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield PharmaciesReportSuccessfully(report);
      } else {
        yield ReportError(error);
      }
    }

    if (event is GetPlannedReport) {
      List<ActualVisitModel> report;
      String error;
      yield ReportLoading();
      await Project.apiClient.getPlannedReport(event.id).then((onValue) {
        report = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield PlannedReportSuccessfully(report);
      } else {
        yield ReportError(error);
      }
    }
  }
}
