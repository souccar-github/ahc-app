import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/actual_bloc.dart';
import 'package:template/Bloc/Project/bloc/hospitalactualtask_bloc.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/DropdownItemModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Screens/Project/ActualTasks.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/AutoCompleteTextField.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/Dropdown.dart';
import 'package:template/Widgets/General/TextFormField.dart';

class HospitalActualTask extends StatefulWidget {
  final int monthId;
  final bool isUpdate;
  final ActualBloc bloc;
  final ListItemModel task;
  HospitalActualTask(this.monthId, this.isUpdate, this.task, this.bloc);
  @override
  _HospitalActualTask createState() => _HospitalActualTask();
}

class _HospitalActualTask extends State<HospitalActualTask> {
  var actualTask;
  int hosId, day;
  final _formKey = new GlobalKey<FormState>();
  String note;
  List<DropdownMenuItem<DropDownListItem>> _dropdownMenuItems;
  DropDownListItem _selectedItem;
  bool slValue, isImportant, isChanged;

  @override
  void initState() {
    actualTask = new HospitalactualtaskBloc();
    if (widget.isUpdate == false) {
      actualTask.add(InitHosActualAdd());
    }
    if (widget.isUpdate == true) {
      actualTask.add(InitHosActualUpdate(widget.task.id));
    }
    _selectedItem = null;
    slValue = false;
    isChanged = false;
    isImportant = false;
    super.initState();
  }

  List<DropdownMenuItem<DropDownListItem>> buildDropdownMenuItems(
      List<ListItemModel> priods) {
    List<DropdownMenuItem<DropDownListItem>> items = List();
    for (ListItemModel priod in priods) {
      items.add(
        DropdownMenuItem(
          value: new DropDownListItem(priod.id, priod.title),
          child: Text(priod.title),
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

  onChangeDropdownItem(DropDownListItem selectedItem) {
    setState(() {
      _selectedItem = selectedItem;
    });
  }

  onChangeTextField(String value) {
    setState(() {
      note = value;
    });
  }

  onChangeDayTextField(String value) {
    setState(() {
      day = int.parse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Localization.of(context).getTranslatedValue("HospitalActualTask"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<HospitalactualtaskBloc, HospitalactualtaskState>(
        cubit: actualTask,
        listenWhen: (previous, current) => current is HosActualError,
        listener: (context, state) {
          if (state is HosActualError) {
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
          child: BlocBuilder<HospitalactualtaskBloc, HospitalactualtaskState>(
            cubit: actualTask,
            buildWhen: (previous, current) =>
                current is InitUpdateHosSuccessfully ||
                current is CreateHosSuccessfully ||
                current is UpdateHosSuccessfully ||
                current is InitUpdateHosActualSuccessfully ||
                current is HosActualLoading ||
                current is InitAddHosActualSuccessfully,
            builder: (context, state) {
              if (state is InitAddHosActualSuccessfully) {
                List<String> hosList = toList(state.hoList);
                if (_dropdownMenuItems == null)
                  _dropdownMenuItems = buildDropdownMenuItems(state.prList);
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
                                        text: Localization.of(context).getTranslatedValue("Dayofmonth"),
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
                                        55 /
                                        100,
                                    child: textFormField(
                                        onChangeDayTextField,
                                        Localization.of(context).getTranslatedValue("Typethenumberofdayinmonth"),
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
                                  Text(Localization.of(context).getTranslatedValue("Isshortlist")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: slValue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        slValue = value;
                                        if (value == false) {
                                          actualTask.add(InitHosActualAdd());
                                        } else {
                                          actualTask
                                              .add(InitHosActualAddShort());
                                        }
                                      });
                                    },
                                  ),
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
                                        text: Localization.of(context).getTranslatedValue("Hospitals"),
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
                                      hosList,
                                      Localization.of(context).getTranslatedValue("Chooseahospital"),
                                      (value) {
                                        setState(() {
                                          ListItemModel hos = state.hoList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          hosId = hos.id;
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
                                  Text(Localization.of(context).getTranslatedValue("Priod")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(context, _selectedItem, Localization.of(context).getTranslatedValue("Priod"),
                                      _dropdownMenuItems, onChangeDropdownItem),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text(Localization.of(context).getTranslatedValue("IsImportant")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: isImportant,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isImportant = value;
                                      });
                                    },
                                  ),
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text(Localization.of(context).getTranslatedValue("Note")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: textFormField(
                                        onChangeTextField,
                                        Localization.of(context).getTranslatedValue("Typeanote"),
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
                                child: button(Localization.of(context).getTranslatedValue("Submit"), () {
                                  if (_formKey.currentState.validate()) {
                                    if (hosId == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          Localization.of(context).getTranslatedValue("HospitalFieldIsRequired"),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      ActualModel task = new ActualModel(
                                          null,
                                          widget.monthId,
                                          hosId,
                                          slValue,
                                          null,
                                          null,
                                          day,
                                          isImportant,
                                          note,
                                          _selectedItem == null
                                              ? null
                                              : _selectedItem.id,
                                          null);
                                      actualTask.add(CreateHosActual(task));
                                    }
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is InitUpdateHosActualSuccessfully) {
                Future.delayed(Duration.zero, () async {
                  if (isChanged == false) {
                    if (_dropdownMenuItems == null)
                      _dropdownMenuItems = buildDropdownMenuItems(state.prList);
                    setState(() {
                      hosId = state.hos.hospitalId;
                      isImportant = state.hos.important;
                      slValue = state.hos.isShortList;
                      note = state.hos.visitNote;
                      _selectedItem = _dropdownMenuItems
                          .firstWhere((element) =>
                              element.value.id == state.hos.periodId)
                          .value;
                    });
                    isChanged = true;
                  }
                });
                List<String> hosList = toList(state.hosList);
                if (_dropdownMenuItems == null)
                  _dropdownMenuItems = buildDropdownMenuItems(state.prList);
                Timer(Duration(milliseconds: 500), () {});
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
                                        text: Localization.of(context).getTranslatedValue("Dayofmonth"),
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
                                        55 /
                                        100,
                                    child: textFormField(
                                        onChangeDayTextField,
                                        Localization.of(context).getTranslatedValue("Typethenumberofdayinmonth"),
                                        true,
                                        TextInputType.number,
                                        false,
                                        1,
                                        state.hos.day.toString()),
                                  ),
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text(Localization.of(context).getTranslatedValue("Isshortlist")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: slValue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        slValue = value;
                                        if (value == false) {
                                          actualTask.add(InitHosActualUpdate(
                                              widget.task.id));
                                        } else {
                                          actualTask.add(
                                              InitHosActualUpdateShort(
                                                  widget.task.id));
                                        }
                                      });
                                    },
                                  ),
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
                                        text: Localization.of(context).getTranslatedValue("Hospitals"),
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
                                          text: widget.task.title),
                                      hosList,
                                      Localization.of(context).getTranslatedValue("Chooseahospital"),
                                      (value) {
                                        setState(() {
                                          ListItemModel hos = state.hosList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          hosId = hos.id;
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
                                  Text(Localization.of(context).getTranslatedValue("Priod")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(context, _selectedItem, Localization.of(context).getTranslatedValue("Priod"),
                                      _dropdownMenuItems, onChangeDropdownItem),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text(Localization.of(context).getTranslatedValue("IsImportant")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: isImportant,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isImportant = value;
                                      });
                                    },
                                  ),
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text(Localization.of(context).getTranslatedValue("Note")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: textFormField(
                                        onChangeTextField,
                                        Localization.of(context).getTranslatedValue("Typeanote"),
                                        false,
                                        TextInputType.multiline,
                                        false,
                                        5,
                                        state.hos.visitNote),
                                  ),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: button(Localization.of(context).getTranslatedValue("Submit"), () {
                                  if (_formKey.currentState.validate()) {
                                    if (hosId == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          Localization.of(context).getTranslatedValue("HospitalFieldIsRequired"),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      if (day == null)
                                        setState(() {
                                          day = state.hos.day;
                                        });
                                      ActualModel task = new ActualModel(
                                          widget.task.id,
                                          widget.monthId,
                                          hosId,
                                          slValue,
                                          null,
                                          null,
                                          day,
                                          isImportant,
                                          note,
                                          _selectedItem == null
                                              ? null
                                              : _selectedItem.id,
                                          null);
                                      actualTask.add(UpdateHosActual(task));
                                    }
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is UpdateHosSuccessfully) {
                if (state.check) {
                Future.delayed(Duration.zero, () async {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        Localization.of(context).getTranslatedValue("AttentionThisDayIsHoliday"),
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.orange,
                    ));
                  });
                  Timer(Duration(milliseconds: 2000), () {
                Navigator.of(context).pop();
                widget.bloc.add(GetActualTasks(widget.monthId));
                 });} else {
                  Navigator.of(context).pop();
                  widget.bloc.add(GetActualTasks(widget.monthId));
                }
              } else if (state is CreateHosSuccessfully) {
                if (state.check) {
                Future.delayed(Duration.zero, () async {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        Localization.of(context).getTranslatedValue(("AttentionThisDayIsHoliday")),
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.orange,
                    ));
                  });
                  Timer(Duration(milliseconds: 2000), () {
                Navigator.of(context).pop();
                widget.bloc.add(GetActualTasks(widget.monthId));
                 });} else {
                  Navigator.of(context).pop();
                  widget.bloc.add(GetActualTasks(widget.monthId));
                }
              } else if (state is HosActualLoading) {
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
