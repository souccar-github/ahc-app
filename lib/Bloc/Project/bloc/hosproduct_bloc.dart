import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/HosProductModel.dart';

part 'hosproduct_event.dart';
part 'hosproduct_state.dart';

class HosProductBloc extends Bloc<HosProductEvent, HosProductState> {
  HosProductBloc() : super(HosProductInitState());

  @override
  Stream<HosProductState> mapEventToState(
    HosProductEvent event,
  ) async* {
    if (event is InitHosProducts) {
      String error;
      List<ListItemModel> list;
      yield HosProductLoading();
      await Project.apiClient.getHosPro(event.id).then((onValue) {
        list = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitHosProductsSuccessfully(list);
      } else {
        yield HosProductError(error);
      }
    }
    if (event is CreateHosProduct) {
      yield HosProductLoading();
      String success, error = null;
      await Project.apiClient.addHosProduct(event.product).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield CreateHosProductSuccessfully();
      } else {
        yield HosProductError(error);
      }
    }

    if (event is UpdateHosProduct) {
      yield HosProductLoading();
      String success, error = null;
      await Project.apiClient.updateHosProduct(event.product).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield UpdateHosProductSuccessfully();
      } else {
        yield HosProductError(error);
      }
    }
    if (event is DeleteHosProduct) {
      yield HosProductLoading();
      String error = null, success = null;
      await Project.apiClient.deleteHosProduct(event.id).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield DeleteHosProductSuccessfully();
      } else {
        yield HosProductError(error);
      }
    }
    if (event is InitHosProductAdd) {
      List<ListItemModel> proList, adList, comList,matList;
      String error;
      yield HosProductLoading();
      await Project.apiClient.getProducts().then((onValue) {
        proList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getProvidedMaterial().then((onValue) {
        matList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getAdoptions().then((onValue) {
        adList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getComplaints().then((onValue) {
        comList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddHosProductSuccessfully(proList, adList,matList, comList);
      } else {
        yield HosProductError(error);
      }
    }

    if (event is InitHosProductUpdate) {
      List<ListItemModel> proList, adList, comList,matList;
      HosProductModel product;
      String error;
      yield HosProductLoading();
      await Project.apiClient.getProducts().then((onValue) {
        proList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getProvidedMaterial().then((onValue) {
        matList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getAdoptions().then((onValue) {
        adList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getComplaints().then((onValue) {
        comList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getHosProduct(event.id).then((onValue) {
        product = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdateHosProductSuccessfully(
            proList, adList,matList, comList, product);
      } else {
        yield HosProductError(error);
      }
    }
  }
}
