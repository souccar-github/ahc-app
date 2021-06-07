part of 'report_bloc.dart';

abstract class ReportEvent {}

class GetHospitalsReport extends ReportEvent {
  final int id;
  GetHospitalsReport(this.id);
}

class GetPhysiciansReport extends ReportEvent {
  final int id;
  GetPhysiciansReport(this.id);
}

class GetPharmaciesReport extends ReportEvent {
  final int id;
  GetPharmaciesReport(this.id);
}

class GetPlannedReport extends ReportEvent {
  final int id;
  GetPlannedReport(this.id);
}

