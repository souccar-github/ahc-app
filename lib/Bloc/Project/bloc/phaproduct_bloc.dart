import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/PhaProductModel.dart';

part 'phaproduct_event.dart';
part 'phaproduct_state.dart';

class PhaProductBloc extends Bloc<PhaProductEvent, PhaProductState> {
  PhaProductBloc() : super(PhaProductInitState());

  @override
  Stream<PhaProductState> mapEventToState(
    PhaProductEvent event,
  ) async* {
    if (event is InitPhaProducts) {
      String error;
      List<ListItemModel> list;
      yield PhaProductLoading();
      await Project.apiClient.getPhaPro(event.id).then((onValue) {
        list = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitPhaProductsSuccessfully(list);
      } else {
        yield PhaProductError(error);
      }
    }
    if (event is UpdatePhaProduct) {
      yield PhaProductLoading();
      String success, error = null;
      await Project.apiClient.updatePhaProduct(event.product).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });
      

      if (error == null) {
        yield UpdatePhaProductSuccessfully();
      } else {
        yield PhaProductError(error);
      }
    }

    if (event is DeletePhaProduct) {
      yield PhaProductLoading();
      String error = null, success = null;
      await Project.apiClient.deletePhaProduct(event.id).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield DeletePhaProductSuccessfully();
      } else {
        yield PhaProductError(error);
      }
    }
    if (event is CreatePhaProduct) {
      yield PhaProductLoading();
      String success, error = null;
      await Project.apiClient.addPhaProduct(event.product).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield CreatePhaProductSuccessfully();
      } else {
        yield PhaProductError(error);
      }
    }
    if (event is InitPhaProductAdd) {
      List<ListItemModel> proList;
      List<ListItemModel> matList;
      String error;
      yield PhaProductLoading();
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
      if (error == null) {
        yield InitAddPhaProductSuccessfully(proList,matList);
      } else {
        yield PhaProductError(error);
      }
    }

    if (event is InitPhaProductUpdate) {
      List<ListItemModel> proList;
      List<ListItemModel> matList;
      PhaProductModel product;
      String error;
      
      yield PhaProductLoading();
      await Project.apiClient.getProducts().then((onValue) {
        proList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPhaProduct(event.id).then((onValue) {
        product = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getProvidedMaterial().then((onValue) {
        matList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdatePhaProductSuccessfully(proList, product,matList);
      } else {
        yield PhaProductError(error);
      }
    }
  }
}
