part of 'clinic_bloc.dart';

abstract class ClinicEvent {}

class InitClinicAdd extends ClinicEvent {}

class InitClinicUpdate extends ClinicEvent {
  final int id;
  InitClinicUpdate(this.id);
}

class CreateClinic extends ClinicEvent {
  final ClinicModel clinic;
  CreateClinic(this.clinic);
}

class UpdateClinic extends ClinicEvent {
  final ClinicModel clinic;
  UpdateClinic(this.clinic);
}

class InitClinics extends ClinicEvent {
  final int id;
  InitClinics(this.id);
}

class DeleteClinic extends ClinicEvent {
  final int id;
  DeleteClinic(this.id);
}
