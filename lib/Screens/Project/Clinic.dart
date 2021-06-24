import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/clinic_bloc.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Models/Project/DropdownItemModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/ClinicModel.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/AutoCompleteTextField.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/Dropdown.dart';
import 'package:template/Widgets/General/TextFormField.dart';

class Clinic extends StatefulWidget {
  final int id;
  final ClinicBloc bloc;
  final bool isUpdate;
  Clinic(this.id, this.bloc, this.isUpdate);
  @override
  _Clinic createState() => _Clinic();
}

class _Clinic extends State<Clinic> {
  var clinicBloc;
  int clinicId, id;
  bool isChanged;
  final _formKey = new GlobalKey<FormState>();
  List<DropdownMenuItem<DropDownListItem>> _clinicDropdownMenuItems,
      _visitTypeDropdownMenuItems;
  DropDownListItem _clinicSelectedItem, _visitTypeSelectedItem;

  @override
  void initState() {
    clinicBloc = new ClinicBloc();
    if (widget.isUpdate == false)
      clinicBloc.add(InitClinicAdd());
    else
      clinicBloc.add(InitClinicUpdate(widget.id));
    _clinicSelectedItem = null;
    _visitTypeSelectedItem = null;
    isChanged = false;
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

  onChangeDropdownItemClinic(DropDownListItem selectedItem) {
    setState(() {
      _clinicSelectedItem = selectedItem;
    });
  }

  onChangeDropdownItemVisitType(DropDownListItem selectedItem) {
    setState(() {
      _visitTypeSelectedItem = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Localization.of(context).getTranslatedValue("Clinic"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<ClinicBloc, ClinicState>(
        cubit: clinicBloc,
        listenWhen: (previous, current) => current is ClinicError,
        listener: (context, state) {
          if (state is ClinicError) {
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
          child: BlocBuilder<ClinicBloc, ClinicState>(
            cubit: clinicBloc,
            buildWhen: (previous, current) =>
                current is InitUpdateClinicSuccessfully ||
                current is ClinicLoading ||
                current is CreateClinicSuccessfully ||
                current is UpdateClinicSuccessfully ||
                current is InitAddClinicSuccessfully,
            builder: (context, state) {
              if (state is InitAddClinicSuccessfully) {
                if (_clinicDropdownMenuItems == null)
                  _clinicDropdownMenuItems =
                      buildDropdownMenuItems(state.clinicList);
                if (_visitTypeDropdownMenuItems == null)
                  _visitTypeDropdownMenuItems =
                      buildDropdownMenuItems(state.typeList);
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
                                  RichText(
                                    text: TextSpan(
                                        text: Localization.of(context).getTranslatedValue("Clinics"),
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
                                      _clinicSelectedItem,
                                      Localization.of(context).getTranslatedValue("Clinic"),
                                      _clinicDropdownMenuItems,
                                      onChangeDropdownItemClinic),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                        text: Localization.of(context).getTranslatedValue("VisitTypes"),
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
                                      _visitTypeSelectedItem,
                                      Localization.of(context).getTranslatedValue("VisitType"),
                                      _visitTypeDropdownMenuItems,
                                      onChangeDropdownItemVisitType),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: button(Localization.of(context).getTranslatedValue("Submit"), () {
                                  if (_clinicSelectedItem == null ||
                                      _visitTypeSelectedItem == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        Localization.of(context).getTranslatedValue("ClinicandVisitTypeFieldsAreRequired"),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    ClinicModel clinic = new ClinicModel(
                                        0,
                                        _clinicSelectedItem.id,
                                        _visitTypeSelectedItem.id,
                                        widget.id);
                                    clinicBloc.add(CreateClinic(clinic));
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is InitUpdateClinicSuccessfully) {
                Future.delayed(Duration.zero, () async {
                  if (isChanged == false) {
                    setState(() {
                      if (_clinicDropdownMenuItems == null)
                        _clinicDropdownMenuItems =
                            buildDropdownMenuItems(state.clinicList);
                      if (_visitTypeDropdownMenuItems == null)
                        _visitTypeDropdownMenuItems =
                            buildDropdownMenuItems(state.typeList);

                      _clinicSelectedItem = _clinicDropdownMenuItems
                          .firstWhere((element) =>
                              element.value.id == state.clinic.clinicId)
                          .value;
                      _visitTypeSelectedItem = _visitTypeDropdownMenuItems
                          .firstWhere((element) =>
                              element.value.id == state.clinic.visitTypeId)
                          .value;
                      id = state.clinic.hospitalVisitId;
                      isChanged = true;
                    });
                  }
                });
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
                                   RichText(
                                    text: TextSpan(
                                        text: Localization.of(context).getTranslatedValue("Clinics"),
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
                                      _clinicSelectedItem,
                                      Localization.of(context).getTranslatedValue("Clinic"),
                                      _clinicDropdownMenuItems,
                                      onChangeDropdownItemClinic),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                   RichText(
                                    text: TextSpan(
                                        text: Localization.of(context).getTranslatedValue("VisitTypes"),
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
                                      _visitTypeSelectedItem,
                                      Localization.of(context).getTranslatedValue("VisitType"),
                                      _visitTypeDropdownMenuItems,
                                      onChangeDropdownItemVisitType),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: button(Localization.of(context).getTranslatedValue("Submit"), () {
                                  if (_clinicSelectedItem == null ||
                                      _visitTypeSelectedItem == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        Localization.of(context).getTranslatedValue("ClinicandVisitTypeFieldsAreRequired"),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    ClinicModel clinic = new ClinicModel(
                                        widget.id,
                                        _clinicSelectedItem.id,
                                        _visitTypeSelectedItem.id,
                                        state.clinic.hospitalVisitId);
                                    clinicBloc.add(UpdateClinic(clinic));
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is CreateClinicSuccessfully) {
                Navigator.of(context).pop();
                widget.bloc.add(InitClinics(widget.id));
              } else if (state is UpdateClinicSuccessfully) {
                Navigator.of(context).pop();
                widget.bloc.add(InitClinics(id));
              } else if (state is ClinicLoading) {
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
