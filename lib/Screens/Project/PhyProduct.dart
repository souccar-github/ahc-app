import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/physicianproduct_bloc.dart';
import 'package:template/Models/Project/DropdownItemModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/PhyProductModel.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/AutoCompleteTextField.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/Dropdown.dart';
import 'package:template/Widgets/General/TextFormField.dart';

class PhysicianProduct extends StatefulWidget {
  final int id;
  final PhysicianProductBloc bloc;
  final bool isUpdate;
  PhysicianProduct(this.id, this.bloc, this.isUpdate);
  @override
  _PhysicianProduct createState() => _PhysicianProduct();
}

class _PhysicianProduct extends State<PhysicianProduct> {
  var pharmacyProductBloc;
  int productId, count, id;
  final _formKey = new GlobalKey<FormState>();
  String note;
  List<DropdownMenuItem<DropDownListItem>> _adoptionDropdownMenuItems,
      _providedMaterialDropdownMenuItems,
      _complaintDropdownMenuItems;
  DropDownListItem _adoptionSelectedItem,
      _complaintSelectedItem,
      _providedMaterialSelectedItem;
  bool slValue, isImportant, isChanged;

  @override
  void initState() {
    pharmacyProductBloc = new PhysicianProductBloc();
    if (widget.isUpdate == false)
      pharmacyProductBloc.add(InitPhysicianProductAdd());
    else
      pharmacyProductBloc.add(InitPhyProductUpdate(widget.id));
    _adoptionSelectedItem = null;
    _providedMaterialSelectedItem = null;
    _complaintSelectedItem = null;
    slValue = false;
    isChanged = false;
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

  onChangeCountTextField(String value) {
    setState(() {
      count = int.parse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Physician Product',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<PhysicianProductBloc, PhysicianProductState>(
        cubit: pharmacyProductBloc,
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<PhysicianProductBloc, PhysicianProductState>(
            cubit: pharmacyProductBloc,
            buildWhen: (previous, current) =>
                current is InitUpdatePhysicianProductSuccessfully ||
                current is PhysicianProductLoading ||
                current is CreatePhysicianProductSuccessfully ||
                current is UpdatePhyProductSuccessfully ||
                current is InitAddPhysicianProductSuccessfully,
            // ignore: missing_return
            builder: (context, state) {
              if (state is InitAddPhysicianProductSuccessfully) {
                List<String> prList = toList(state.proList);
                if (_adoptionDropdownMenuItems == null)
                  _adoptionDropdownMenuItems =
                      buildDropdownMenuItems(state.adList);
                if (_complaintDropdownMenuItems == null)
                  _complaintDropdownMenuItems =
                      buildDropdownMenuItems(state.comList);
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
                                  Text("Products"),
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
                                  Text("Adoptions"),
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
                                  Text("Provided Materials"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(
                                      context,
                                      _providedMaterialSelectedItem,
                                      "Provided Material",
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
                                    PhyProductModel product =
                                        new PhyProductModel(
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
                                    pharmacyProductBloc
                                        .add(CreatePhysicianProduct(product));
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is InitUpdatePhysicianProductSuccessfully) {
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
                      id = state.product.physicianVisitId;
                      count = state.product.sample;
                      note = state.product.productNote;
                      productId = state.product.productId;
                      isChanged = true;
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
                                  Text("Products"),
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
                                  Text("Adoptions"),
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
                                  Text("Provided Materials"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(
                                      context,
                                      _providedMaterialSelectedItem,
                                      "Provided Material",
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
                                    PhyProductModel product =
                                        new PhyProductModel(
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
                                            state.product.physicianVisitId,
                                            productId ??
                                                state.product.productId,
                                            count ?? state.product.sample,
                                            note == ""
                                                ? state.product.productNote
                                                : note);
                                    pharmacyProductBloc
                                        .add(UpdatePhyProduct(product));
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is CreatePhysicianProductSuccessfully) {
                Navigator.of(context).pop();
                widget.bloc.add(InitPhysicianProducts(widget.id));
              } else if (state is UpdatePhyProductSuccessfully) {
                Navigator.of(context).pop();
                widget.bloc.add(InitPhysicianProducts(id));
              } else if (state is PhysicianProductLoading) {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
