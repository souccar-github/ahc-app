import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/PhyProductModel.dart';

part 'physicianproduct_event.dart';
part 'physicianproduct_state.dart';

class PhysicianProductBloc
    extends Bloc<PhysicianProductEvent, PhysicianProductState> {
  PhysicianProductBloc() : super(PhysicianProductInitState());

  @override
  Stream<PhysicianProductState> mapEventToState(
    PhysicianProductEvent event,
  ) async* {
    if (event is InitPhysicianProducts) {
      String error;
      List<ListItemModel> list;
      yield PhysicianProductLoading();
      await Project.apiClient.getPhyPro(event.id).then((onValue) {
        list = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitPhysicianProductsSuccessfully(list);
      } else {
        yield PhysicianProductError(error);
      }
    }
    if (event is CreatePhysicianProduct) {
      yield PhysicianProductLoading();
      String success, error = null;
      await Project.apiClient.addPhyProduct(event.product).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield CreatePhysicianProductSuccessfully();
      } else {
        yield PhysicianProductError(error);
      }
    }
    if (event is DeletePhyProduct) {
      yield PhysicianProductLoading();
      String error = null, success = null;
      await Project.apiClient.deletePhyProduct(event.id).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield DeletePhyProductSuccessfully();
      } else {
        yield PhysicianProductError(error);
      }
    }
    if (event is UpdatePhyProduct) {
      yield PhysicianProductLoading();
      String success, error = null;
      await Project.apiClient.updatePhyProduct(event.product).then((onValue) {
        success = onValue;
      }).catchError((onError) {
        error = onError;
      });

      if (error == null) {
        yield UpdatePhyProductSuccessfully();
      } else {
        yield PhysicianProductError(error);
      }
    }
    if (event is InitPhyProductUpdate) {
      List<ListItemModel> proList, adList, comList,matList;
      PhyProductModel product;
      String error;
      yield PhysicianProductLoading();
      await Project.apiClient.getProducts().then((onValue) {
        proList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getAdoptions().then((onValue) {
        adList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getProvidedMaterial().then((onValue) {
        matList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getComplaints().then((onValue) {
        comList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getPhyProduct(event.id).then((onValue) {
        product = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitUpdatePhysicianProductSuccessfully(
            proList, adList, comList, product,matList);
      } else {
        yield PhysicianProductError(error);
      }
    }

    if (event is InitPhysicianProductAdd) {
      List<ListItemModel> proList, adList, comList,matList;
      String error;
      yield PhysicianProductLoading();
      await Project.apiClient.getProducts().then((onValue) {
        proList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getAdoptions().then((onValue) {
        adList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getProvidedMaterial().then((onValue) {
        matList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      await Project.apiClient.getComplaints().then((onValue) {
        comList = onValue;
      }).catchError((onError) {
        error = onError;
      });
      if (error == null) {
        yield InitAddPhysicianProductSuccessfully(proList, adList, comList,matList);
      } else {
        yield PhysicianProductError(error);
      }
    }
  }
}
