import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/hosproduct_bloc.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/DropdownItemModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/HosProductModel.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/AutoCompleteTextField.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/Dropdown.dart';
import 'package:template/Widgets/General/TextFormField.dart';

class HosProduct extends StatefulWidget {
  final int id;
  final HosProductBloc bloc;
  final bool isUpdate;

  HosProduct(this.id, this.bloc, this.isUpdate);
  @override
  _HosProduct createState() => _HosProduct();
}

class _HosProduct extends State<HosProduct> {
  var hosProductBloc;
  int productId, count, id;
  final _formKey = new GlobalKey<FormState>();
  String note;
  List<DropdownMenuItem<DropDownListItem>> _adoptionDropdownMenuItems,
      _providedMaterialDropdownMenuItems,
      _complaintDropdownMenuItems;
  DropDownListItem _adoptionSelectedItem,
      _providedMaterialSelectedItem,
      _complaintSelectedItem;
  bool slValue, isImportant, isChanged;

  @override
  void initState() {
    hosProductBloc = new HosProductBloc();
    if (widget.isUpdate == false)
      hosProductBloc.add(InitHosProductAdd());
    else
      hosProductBloc.add(InitHosProductUpdate(widget.id));
    _adoptionSelectedItem = null;
    _complaintSelectedItem = null;
    _providedMaterialSelectedItem = null;
    isChanged = false;
    slValue = false;
    note = "";
    isImportant = false;
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

  onChangeDropdownItemAdoption(DropDownListItem selectedItem) {
    setState(() {
      _adoptionSelectedItem = selectedItem;
    });
  }

  onChangeDropdownItemProvidedMaterial(DropDownListItem selectedItem) {
    setState(() {
      _providedMaterialSelectedItem = selectedItem;
    });
  }

  onChangeDropdownItemComplaint(DropDownListItem selectedItem) {
    setState(() {
      _complaintSelectedItem = selectedItem;
    });
  }

  onChangeTextField(String value) {
    setState(() {
      note = value;
    });
  }

  onChangeDayTextField(String value) {
    setState(() {
      count = int.parse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clinic Product',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<HosProductBloc, HosProductState>(
        cubit: hosProductBloc,
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<HosProductBloc, HosProductState>(
            cubit: hosProductBloc,
            buildWhen: (previous, current) =>
                current is InitUpdateHosProductSuccessfully ||
                current is HosProductLoading ||
                current is CreateHosProductSuccessfully ||
                current is UpdateHosProductSuccessfully ||
                current is InitAddHosProductSuccessfully,
            builder: (context, state) {
              if (state is InitAddHosProductSuccessfully) {
                List<String> prList = toList(state.proList);
                if (_adoptionDropdownMenuItems == null)
                  _adoptionDropdownMenuItems =
                      buildDropdownMenuItems(state.adoptionList);
                if (_complaintDropdownMenuItems == null)
                  _complaintDropdownMenuItems =
                      buildDropdownMenuItems(state.complaintList);
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
                                        onChangeDayTextField,
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
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red))
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
                                  RichText(
                                    text: TextSpan(
                                        text:"Adoptions",
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(
                                      context,
                                      _adoptionSelectedItem,
                                      "Adoption",
                                      _adoptionDropdownMenuItems,
                                      onChangeDropdownItemAdoption),
                                ]),
                                delay: 100,
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
                                  Text("Complaints"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(
                                      context,
                                      _complaintSelectedItem,
                                      "Complaint",
                                      _complaintDropdownMenuItems,
                                      onChangeDropdownItemComplaint),
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
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: button("Submit", () {
                                  if (productId == null ||
                                      _adoptionSelectedItem == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "Product and Adoption Fields Are Required",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    HosProductModel product =
                                        new HosProductModel(
                                            0,
                                            _adoptionSelectedItem.id,
                                            _providedMaterialSelectedItem ==
                                                    null
                                                ? null
                                                : _providedMaterialSelectedItem
                                                    .id,
                                            _complaintSelectedItem == null
                                                ? null
                                                : _complaintSelectedItem.id,
                                            widget.id,
                                            productId,
                                            count,
                                            note);
                                    hosProductBloc
                                        .add(CreateHosProduct(product));
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is InitUpdateHosProductSuccessfully) {
                Future.delayed(Duration.zero, () async {
                  setState(() {
                    if (isChanged == false) {
                      if (_adoptionDropdownMenuItems == null)
                        _adoptionDropdownMenuItems =
                            buildDropdownMenuItems(state.adoptionList);
                      if (_complaintDropdownMenuItems == null)
                        _complaintDropdownMenuItems =
                            buildDropdownMenuItems(state.complaintList);
                      if (_providedMaterialDropdownMenuItems == null)
                        _providedMaterialDropdownMenuItems =
                            buildDropdownMenuItems(state.matList);
                      _adoptionSelectedItem = _adoptionDropdownMenuItems
                          .firstWhere((element) =>
                              element.value.id == state.product.adoptionId)
                          .value;
                      _complaintSelectedItem = state.product.complaintId == null ?null : _complaintDropdownMenuItems
                          .firstWhere((element) =>
                              element.value.id == state.product.complaintId)
                          .value;
                      _providedMaterialSelectedItem =state.product.matId == null ?null :
                          _providedMaterialDropdownMenuItems
                              .firstWhere((element) =>
                                  element.value.id == state.product.matId)
                              .value;
                      isChanged = true;
                      productId = state.product.productId;
                      id = state.product.hospitalClinicVisitId;
                    }
                  });
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
                                        onChangeDayTextField,
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
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red))
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
                                 RichText(
                                    text: TextSpan(
                                        text:"Adoptions",
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(
                                      context,
                                      _adoptionSelectedItem,
                                      "Adoption",
                                      _adoptionDropdownMenuItems,
                                      onChangeDropdownItemAdoption),
                                ]),
                                delay: 100,
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
                                  Text("Complaints"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(
                                      context,
                                      _complaintSelectedItem,
                                      "Complaint",
                                      _complaintDropdownMenuItems,
                                      onChangeDropdownItemComplaint),
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
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: button("Submit", () {
                                  if (productId == null ||
                                      _adoptionSelectedItem == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "Product and Adoption Fields Are Required",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    HosProductModel product =
                                        new HosProductModel(
                                            widget.id,
                                            _adoptionSelectedItem.id,
                                            _providedMaterialSelectedItem ==
                                                    null
                                                ? null
                                                : _providedMaterialSelectedItem
                                                    .id,
                                            _complaintSelectedItem == null
                                                ? null
                                                : _complaintSelectedItem.id,
                                            state.product.hospitalClinicVisitId,
                                            productId ??
                                                state.product.productId,
                                            count ?? state.product.sample,
                                            note == ""
                                                ? state.product.productNote
                                                : note);
                                    hosProductBloc
                                        .add(UpdateHosProduct(product));
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is CreateHosProductSuccessfully) {
                Navigator.of(context).pop();
                widget.bloc.add(InitHosProducts(widget.id));
              } else if (state is UpdateHosProductSuccessfully) {
                Navigator.of(context).pop();
                widget.bloc.add(InitHosProducts(id));
              } else if (state is HosProductLoading) {
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
