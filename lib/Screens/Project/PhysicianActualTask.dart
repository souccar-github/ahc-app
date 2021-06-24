import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/actual_bloc.dart';
import 'package:template/Bloc/Project/bloc/physicianactualtask_bloc.dart';
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

class PhysicianActualTask extends StatefulWidget {
  final int monthId;
  final bool isUpdate;
  final ActualBloc bloc;
  final ListItemModel task;

  PhysicianActualTask(this.monthId, this.isUpdate, this.task, this.bloc);
  @override
  _PhysicianActualTask createState() => _PhysicianActualTask();
}

class _PhysicianActualTask extends State<PhysicianActualTask> {
  var actualTask;
  int phyId, day;
  List<String> drList;

  final _formKey = new GlobalKey<FormState>();
  String note;
  List<DropdownMenuItem<DropDownListItem>> _dropdownMenuItems;
  DropDownListItem _selectedItem;
  bool slValue, isImportant, isChanged;

  @override
  void initState() {
    actualTask = new PhysicianactualtaskBloc();
    if (widget.isUpdate == false) {
      actualTask.add(InitPhyActualAdd());
    }
    if (widget.isUpdate == true) {
      actualTask.add(InitPhyActualUpdate(widget.task.id));
    }
    _selectedItem = null;
    slValue = false;
    note = "";
    isImportant = false;
    isChanged = false;
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

  mapValues(InitUpdatePhyActualSuccessfully state) {
    setState(() {
      phyId = state.phy.physicianId;
      note = state.phy.visitNote;
      isImportant = state.phy.important;
      slValue = state.phy.isShortList;
      _selectedItem = _dropdownMenuItems
          .firstWhere((element) => element.value.id == state.phy.periodId)
          .value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Localization.of(context).getTranslatedValue("PhysicianActualTask"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<PhysicianactualtaskBloc, PhysicianactualtaskState>(
        cubit: actualTask,
        listenWhen: (previous, current) => current is PhyActualError,
        listener: (context, state) {
          if (state is PhyActualError) {
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
          child: BlocBuilder<PhysicianactualtaskBloc, PhysicianactualtaskState>(
            cubit: actualTask,
            buildWhen: (previous, current) =>
                current is InitUpdatePhyActualSuccessfully ||
                current is PhyActualLoading ||
                current is UpdatePhySuccessfully ||
                current is CreatePhySuccessfully ||
                current is InitAddPhyActualSuccessfully,
            // ignore: missing_return
            builder: (context, state) {
              if (state is InitAddPhyActualSuccessfully) {
                List<String> drList = toList(state.drList);
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
                                          actualTask.add(InitPhyActualAdd());
                                        } else {
                                          actualTask
                                              .add(InitPhyActualAddShort());
                                        }
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
                                  RichText(
                                    text: TextSpan(
                                        text: Localization.of(context).getTranslatedValue("Physicians"),
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
                                      drList,
                                      Localization.of(context).getTranslatedValue("Chooseaphysician"),
                                      (value) {
                                        setState(() {
                                          ListItemModel phy = state.drList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          phyId = phy.id;
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
                                delay: 100,
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
                                    if (phyId == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          Localization.of(context).getTranslatedValue("PhysicianFieldIsRequired"),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      ActualModel task = new ActualModel(
                                          null,
                                          widget.monthId,
                                          null,
                                          slValue,
                                          null,
                                          phyId,
                                          day,
                                          isImportant,
                                          note,
                                          _selectedItem == null
                                              ? null
                                              : _selectedItem.id,
                                          null);
                                      actualTask.add(CreatePhyActual(task));
                                    }
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is InitUpdatePhyActualSuccessfully) {
                Future.delayed(Duration.zero, () async {
                  if (isChanged == false) {
                    if (_dropdownMenuItems == null)
                      _dropdownMenuItems = buildDropdownMenuItems(state.prList);
                    if (_dropdownMenuItems == null)
                      _dropdownMenuItems = buildDropdownMenuItems(state.prList);
                    mapValues(state);
                    isChanged = true;
                  }
                });
                drList = toList(state.drList);
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
                                        state.phy.day.toString()),
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
                                          actualTask.add(InitPhyActualUpdate(
                                              widget.task.id));
                                        } else {
                                          actualTask.add(
                                              InitPhyActualUpdateShort(
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
                                        text: Localization.of(context).getTranslatedValue("Physicians"),
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
                                    child: autoCompleteTextField(
                                      new TextEditingController(
                                          text: widget.task.title),
                                      drList,
                                      Localization.of(context).getTranslatedValue("Chooseaphysician"),
                                      (value) {
                                        setState(() {
                                          ListItemModel phy = state.drList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          phyId = phy.id;
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
                                        state.phy.visitNote),
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
                                    if (phyId == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          Localization.of(context).getTranslatedValue("PhysicianFieldIsRequired"),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      if (day == null)
                                        setState(() {
                                          day = state.phy.day;
                                        });
                                      ActualModel task = new ActualModel(
                                          widget.task.id,
                                          widget.monthId,
                                          null,
                                          slValue,
                                          null,
                                          phyId,
                                          day,
                                          isImportant,
                                          note,
                                          _selectedItem == null
                                              ? null
                                              : _selectedItem.id,
                                          null);
                                      actualTask.add(UpdatePhyActual(task));
                                    }
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is CreatePhySuccessfully) {
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
                  });
                } else {
                  Navigator.of(context).pop();
                  widget.bloc.add(GetActualTasks(widget.monthId));
                }
              } else if (state is UpdatePhySuccessfully) {
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
                  });
                } else {
                  Navigator.of(context).pop();
                  widget.bloc.add(GetActualTasks(widget.monthId));
                }
              } else if (state is PhyActualLoading) {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
