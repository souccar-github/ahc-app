import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:template/Bloc/Project/bloc/clinic_bloc.dart';
import 'package:template/Bloc/Project/bloc/hosproduct_bloc.dart';
import 'package:template/Bloc/Project/bloc/phaproduct_bloc.dart';
import 'package:template/Bloc/Project/bloc/physicianproduct_bloc.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Screens/Project/ClinicProduct.dart';
import 'package:template/Screens/Project/PhaProduct.dart';
import 'package:template/Screens/Project/PhyProduct.dart';
import 'package:template/Widgets/Project/Drawer.dart';
import 'package:template/Widgets/General/List.dart';

class Products extends StatefulWidget {
  final String type;
  final int id;
  Products(this.type, this.id);
  @override
  _Products createState() => _Products();
}

class _Products extends State<Products> {
  var products;
  @override
  void initState() {
    switch (widget.type) {
      case "PhysicianVisit":
        products = new PhysicianProductBloc();
        products.add(InitPhysicianProducts(widget.id));
        break;
      case "PharmacyVisit":
        products = new PhaProductBloc();
        products.add(InitPhaProducts(widget.id));
        break;
      case "HospitalVisit":
        products = new HosProductBloc();
        products.add(InitHosProducts(widget.id));
        break;
    }
    super.initState();
  }

  deleteProduct(int id, String type) {
    switch (widget.type) {
      case "PhysicianVisit":
        products.add(DeletePhyProduct(id));
        break;
      case "PharmacyVisit":
        products.add(DeletePhaProduct(id));
        break;
      case "HospitalVisit":
        products.add(DeleteHosProduct(id));
        break;
    }
  }

  updateProduct(ListItemModel model) {
    switch (widget.type) {
      case "PhysicianVisit":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PhysicianProduct(model.id, products, true)));
        break;
      case "PharmacyVisit":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PharmacyProduct(model.id, products, true)));
        break;
      case "HospitalVisit":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HosProduct(model.id, products, true)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case "PhysicianVisit":
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PhysicianProduct(widget.id, products, false)));
            },
          ),
          drawer: AppDrawer(),
          appBar: AppBar(
            title: Text(
              Localization.of(context).getTranslatedValue("PhysicianProducts"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: BlocListener<PhysicianProductBloc, PhysicianProductState>(
            cubit: products,
            listenWhen: (previous, current) => current is PhysicianProductError,
            listener: (context, state) {
              if (state is PhysicianProductError) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    state.error,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: BlocBuilder<PhysicianProductBloc, PhysicianProductState>(
              cubit: products,
              buildWhen: (previous, current) =>
                  current is InitPhysicianProductsSuccessfully ||
                  current is DeletePhyProductSuccessfully ||
                  current is PhysicianProductLoading,
              builder: (context, state) {
                if (state is InitPhysicianProductsSuccessfully) {
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: viewList(state.products, deleteProduct,
                          updateProduct, (_) => []));
                } else if (state is DeletePhyProductSuccessfully) {
                  products.add(InitPhysicianProducts(widget.id));
                } else if (state is PhysicianProductLoading) {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
        break;
      case "PharmacyVisit":
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PharmacyProduct(widget.id, products, false)));
            },
          ),
          drawer: AppDrawer(),
          appBar: AppBar(
            title: Text(
              Localization.of(context).getTranslatedValue("PharmacyProducts"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: BlocListener<PhaProductBloc, PhaProductState>(
            cubit: products,
            listenWhen: (previous, current) => current is PhaProductError,
            listener: (context, state) {
              if (state is PhaProductError) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    state.error,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: BlocBuilder<PhaProductBloc, PhaProductState>(
              cubit: products,
              buildWhen: (previous, current) =>
                  current is InitPhaProductsSuccessfully ||
                  current is DeletePhaProductSuccessfully ||
                  current is PhaProductLoading,
              builder: (context, state) {
                if (state is InitPhaProductsSuccessfully) {
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: viewList(state.products, deleteProduct,
                          updateProduct, (_) => []));
                } else if (state is DeletePhaProductSuccessfully) {
                  products.add(InitPhaProducts(widget.id));
                } else if (state is PhaProductLoading) {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
        break;
      case "HospitalVisit":
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      HosProduct(widget.id, products, false)));
            },
          ),
          drawer: AppDrawer(),
          appBar: AppBar(
            title: Text(
              Localization.of(context).getTranslatedValue("ClinicProducts"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: BlocListener<HosProductBloc, HosProductState>(
            cubit: products,
            listenWhen: (previous, current) => current is HosProductError,
            listener: (context, state) {
              if (state is HosProductError) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    state.error,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: BlocBuilder<HosProductBloc, HosProductState>(
              cubit: products,
              buildWhen: (previous, current) =>
                  current is InitHosProductsSuccessfully ||
                  current is DeleteHosProductSuccessfully ||
                  current is HosProductLoading,
              builder: (context, state) {
                if (state is InitHosProductsSuccessfully) {
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: viewList(state.products, deleteProduct,
                          updateProduct, (_) => []));
                } else if (state is DeleteHosProductSuccessfully) {
                  products.add(InitHosProducts(widget.id));
                } else if (state is HosProductLoading) {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
        break;
    }
  }
}
