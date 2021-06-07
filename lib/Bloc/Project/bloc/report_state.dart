part of 'report_bloc.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportError extends ReportState {
  final String error;
  ReportError(this.error);
}

class PhysiciansReportSuccessfully extends ReportState {
  final List<ActualVisitModel> report;
  PhysiciansReportSuccessfully(this.report);
}

class PharmaciesReportSuccessfully extends ReportState {
  final List<ActualVisitModel> report;
  PharmaciesReportSuccessfully(this.report);
}

class HospitalsReportSuccessfully extends ReportState {
  final List<ActualVisitModel> report;
  HospitalsReportSuccessfully(this.report);
}

class PlannedReportSuccessfully extends ReportState {
  final List<ActualVisitModel> report;
  PlannedReportSuccessfully(this.report);
}
