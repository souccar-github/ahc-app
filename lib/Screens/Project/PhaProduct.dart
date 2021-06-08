import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/phaproduct_bloc.dart';
import 'package:template/Bloc/Project/bloc/physicianproduct_bloc.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/DropdownItemModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/PhaProductModel.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/AutoCompleteTextField.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/Dropdown.dart';
import 'package:template/Widgets/General/TextFormField.dart';

class PharmacyProduct extends StatefulWidget {
  final int id;
  final PhaProductBloc bloc;
  final bool isUpdate;
  PharmacyProduct(this.id, this.bloc, this.isUpdate);
  @override
  _PharmacyProduct createState() => _PharmacyProduct();
}

class _PharmacyProduct extends State<PharmacyProduct> {
  var physicianProductBloc;
  int productId, count, id;
  List<DropdownMenuItem<DropDownListItem>> _providedMaterialDropdownMenuItems;
  DropDownListItem _providedMaterialSelectedItem;
  final _formKey = new GlobalKey<FormState>();
  String note;
  bool isExist, isChanged;

  @override
  void initState() {
    isChanged = false;
    physicianProductBloc = new PhaProductBloc();
    if (widget.isUpdate == false)
      physicianProductBloc.add(InitPhaProductAdd());
    else
      physicianProductBloc.add(InitPhaProductUpdate(widget.id));
    isExist = false;
    _providedMaterialSelectedItem = null;
    note = "";
    super.initState();
  }

  List<DropdownMenuItem<DropDownListItem>> buildDropdownMenuItems(
      List<ListItemModel> _items) {
    List<DropdownMenuItem<DropDownListItem>> items = List();
    for (ListItemModel _item in _items) {
      items.add(
        DropdownMenuItem(
          value: new DropDownListItem(_item.id, _item.title),
          child: Text(_item.title),
        ),
      );
    }
    return items;
  }

  List<String> toList(List<ListItemModel> _list) {
    var list = new List<String>();
    for (var i = 0; i < _list.length; i++) {
      list.add(_list[i].title);
    }
    return list;
  }

  onChangeTextField(String value) {
    setState(() {
      note = value;
    });
  }

  onChangeCountTextField(String value) {
    setState(() {
      count = int.parse(value);
    });
  }

  onChangeDropdownItemProvidedMaterial(DropDownListItem selectedItem) {
    setState(() {
      _providedMaterialSelectedItem = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pharmacy Product',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<PhaProductBloc, PhaProductState>(
        cubit: physicianProductBloc,
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<PhaProductBloc, PhaProductState>(
            cubit: physicianProductBloc,
            buildWhen: (previous, current) =>
                current is InitUpdatePhaProductSuccessfully ||
                current is PhaProductLoading ||
                current is CreatePhaProductSuccessfully ||
                current is UpdatePhaProductSuccessfully ||
                current is InitAddPhaProductSuccessfully,
            builder: (context, state) {
              if (state is InitAddPhaProductSuccessfully) {
                List<String> prList = toList(state.proList);
                if (_providedMaterialDropdownMenuItems == null)
                  _providedMaterialDropdownMenuItems =
                      buildDropdownMenuItems(state.matList);
                return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/assets/identety.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Count"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: textFormField(
                                        onChangeCountTextField,
                                        "Type the count of products ...",
                                        true,
                                        TextInputType.number,
                                        false,
                                        1,
                                        null),
                                  ),
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  RichText(
                                            text: TextSpan(
                                                text:"Products",
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                          color: Colors.red))
                                                ]),
                                          ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: autoCompleteTextField(
                                      new TextEditingController(),
                                      prList,
                                      "Choose a Product ...",
                                      (value) {
                                        setState(() {
                                          ListItemModel product = state.proList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          productId = product.id;
                                        });
                                      },
                                    ),
                                  )
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("ProvidedMaterials"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(
                                      context,
                                      _providedMaterialSelectedItem,
                                      "ProvidedMaterial",
                                      _providedMaterialDropdownMenuItems,
                                      onChangeDropdownItemProvidedMaterial),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Note"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: textFormField(
                                        onChangeTextField,
                                        "Type a note ...",
                                        false,
                                        TextInputType.multiline,
                                        false,
                                        5,
                                        null),
                                  ),
                                ]),
                                delay: 100,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Is Exist"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: isExist,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isExist = value;
                                      });
                                    },
                                  ),
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: button("Submit", () {
                                  if (productId == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "Product Field Is Required",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    PhaProductModel product =
                                        new PhaProductModel(
                                            0,
                                            _providedMaterialSelectedItem ==
                                                    null
                                                ? null
                                                : _providedMaterialSelectedItem
                                                    .id,
                                            isExist,
                                            widget.id,
                                            productId,
                                            count,
                                            note);
                                    physicianProductBloc
                                        .add(CreatePhaProduct(product));
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is InitUpdatePhaProductSuccessfully) {
                Future.delayed(Duration.zero, () async {
                  if (isChanged == false) {
                    setState(() {
                      isChanged = true;
                      productId = state.product.productId;
                      id = state.product.pharmacyVisitId;
                      isExist = state.product.availability;
                      if (_providedMaterialDropdownMenuItems == null)
                        _providedMaterialDropdownMenuItems =
                            buildDropdownMenuItems(state.matList);
                      _providedMaterialSelectedItem =
                          state.product.matId == null
                              ? null
                              : _providedMaterialDropdownMenuItems
                                  .firstWhere((element) =>
                                      element.value.id == state.product.matId)
                                  .value;
                    });
                  }
                });
                List<String> prList = toList(state.proList);

                return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/assets/identety.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Count"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: textFormField(
                                        onChangeCountTextField,
                                        "Type the count of products ...",
                                        true,
                                        TextInputType.number,
                                        false,
                                        1,
                                        state.product.sample.toString()),
                                  ),
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  RichText(
                                            text: TextSpan(
                                                text:"Products",
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                          color: Colors.red))
                                                ]),
                                          ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: autoCompleteTextField(
                                      new TextEditingController(
                                          text: state.proList
                                              .firstWhere((element) =>
                                                  element.id ==
                                                  state.product.productId)
                                              .title),
                                      prList,
                                      "Choose a Product ...",
                                      (value) {
                                        setState(() {
                                          ListItemModel product = state.proList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          productId = product.id;
                                        });
                                      },
                                    ),
                                  )
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("ProvidedMaterials"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(
                                      context,
                                      _providedMaterialSelectedItem,
                                      "ProvidedMaterial",
                                      _providedMaterialDropdownMenuItems,
                                      onChangeDropdownItemProvidedMaterial),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Note"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: textFormField(
                                        onChangeTextField,
                                        "Type a note ...",
                                        false,
                                        TextInputType.multiline,
                                        false,
                                        5,
                                        state.product.productNote),
                                  ),
                                ]),
                                delay: 100,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Is Exist"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: isExist,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isExist = value;
                                      });
                                    },
                                  ),
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: button("Submit", () {
                                  if (productId == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "Product Field Is Required",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    PhaProductModel product =
                                        new PhaProductModel(
                                            widget.id,
                                            _providedMaterialSelectedItem ==
                                                    null
                                                ? null
                                                : _providedMaterialSelectedItem
                                                    .id,
                                            isExist,
                                            state.product.pharmacyVisitId,
                                            productId ??
                                                state.product.productId,
                                            count ?? state.product.sample,
                                            note == ""
                                                ? state.product.productNote
                                                : note);
                                    physicianProductBloc
                                        .add(UpdatePhaProduct(product));
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is CreatePhaProductSuccessfully) {
                Navigator.of(context).pop();
                widget.bloc.add(InitPhaProducts(widget.id));
              } else if (state is UpdatePhaProductSuccessfully) {
                Navigator.of(context).pop();
                widget.bloc.add(InitPhaProducts(id));
              } else if (state is PhaProductLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
