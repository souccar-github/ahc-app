part of 'clinic_bloc.dart';

abstract class ClinicState {}

class ClinicInitState extends ClinicState {}

class ClinicError extends ClinicState {
  final String error;
  ClinicError(this.error);
}

class InitCreateClinicSuccessfully extends ClinicState {}

class InitUpdateClinicSuccessfully extends ClinicState {
  final List<ListItemModel> clinicList;
  final List<ListItemModel> typeList;
  final ClinicModel clinic;
  InitUpdateClinicSuccessfully(this.clinicList, this.typeList, this.clinic);
}

class InitAddClinicSuccessfully extends ClinicState {
  final List<ListItemModel> clinicList;
  final List<ListItemModel> typeList;
  InitAddClinicSuccessfully(this.clinicList, this.typeList);
}

class DeleteClinicSuccessfully extends ClinicState {}

class InitUpdateHosSuccessfully extends ClinicState {}

class ClinicLoading extends ClinicState {}

class CreateClinicSuccessfully extends ClinicState {}

class UpdateClinicSuccessfully extends ClinicState {}

class InitClinicsSuccessfully extends ClinicState {
  final List<ListItemModel> clinics;
  InitClinicsSuccessfully(this.clinics);
}
