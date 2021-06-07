import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/ClinicModel.dart';

part 'clinic_event.dart';
part 'clinic_state.dart';

class ClinicBloc extends Bloc<ClinicEvent, ClinicState> {
  ClinicBloc() : super(ClinicInitState());

  @override
  Stream<ClinicState> mapEventToState(
    ClinicEvent event,
  ) async* {
    if (event is InitClinics) {
      String error;
      List<ListItemModel> list;
      yield ClinicLoading();
      await Project.apiClient.getClinics(event.id).then((onValue) {
        list = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitClinicsSuccessfully(list);
      } else {
        yield ClinicError(error);
      }
    }

    if (event is DeleteClinic) {
      yield ClinicLoading();
      String error = null, success = null;
      await Project.apiClient.deleteClinic(event.id).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield DeleteClinicSuccessfully();
      } else {
        yield ClinicError(error);
      }
    }
    if (event is UpdateClinic) {
      yield ClinicLoading();
      String success, error = null;
      await Project.apiClient.updateClinic(event.clinic).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield UpdateClinicSuccessfully();
      } else {
        yield ClinicError(error);
      }
    }
    if (event is CreateClinic) {
      yield ClinicLoading();
      String success, error = null;
      await Project.apiClient.addClinic(event.clinic).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield CreateClinicSuccessfully();
      } else {
        yield ClinicError(error);
      }
    }
    if (event is InitClinicAdd) {
      List<ListItemModel> clinics, visitTypes;
      String error;
      yield ClinicLoading();
      await Project.apiClient.getDropDownClinics().then((onValue) {
        clinics = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getVisitTypes().then((onValue) {
        visitTypes = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddClinicSuccessfully(clinics, visitTypes);
      } else {
        yield ClinicError(error);
      }
    }

    if (event is InitClinicUpdate) {
      List<ListItemModel> clinics, visitTypes;
      ClinicModel clinic;
      String error;
      yield ClinicLoading();
      await Project.apiClient.getClinic(event.id).then((onValue) {
        clinic = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getDropDownClinics().then((onValue) {
        clinics = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getVisitTypes().then((onValue) {
        visitTypes = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdateClinicSuccessfully(clinics, visitTypes, clinic);
      } else {
        yield ClinicError(error);
      }
    }
  }
}
