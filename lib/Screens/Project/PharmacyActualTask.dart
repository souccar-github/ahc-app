import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/actual_bloc.dart';
import 'package:template/Bloc/Project/bloc/pharmacyactualtask_bloc.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/DropdownItemModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/AutoCompleteTextField.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/Dropdown.dart';
import 'package:template/Widgets/General/TextFormField.dart';

class PharmacyActualTask extends StatefulWidget {
  final int monthId;
  final ActualBloc bloc;
  final bool isUpdate;
  final ListItemModel task;
  PharmacyActualTask(this.monthId, this.isUpdate, this.task, this.bloc);
  @override
  _PharmacyActualTask createState() => _PharmacyActualTask();
}

class _PharmacyActualTask extends State<PharmacyActualTask> {
  var actualTask;
  int phaId, day;
  final _formKey = new GlobalKey<FormState>();
  String note;
  List<DropdownMenuItem<DropDownListItem>> _dropdownMenuItems;
  DropDownListItem _selectedItem;
  bool slValue, isImportant, isChanged;

  @override
  void initState() {
    actualTask = new PharmacyactualtaskBloc();
    if (widget.isUpdate == false) {
      actualTask.add(InitPhaActualAdd());
    }
    if (widget.isUpdate == true) {
      actualTask.add(InitPhaActualUpdate(widget.task.id));
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
          'Pharmacy Actual Task',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<PharmacyactualtaskBloc, PharmacyactualtaskState>(
        cubit: actualTask,
        listenWhen: (previous, current) => current is PhaActualError,
        listener: (context, state) {
          if (state is PhaActualError) {
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
          child: BlocBuilder<PharmacyactualtaskBloc, PharmacyactualtaskState>(
            cubit: actualTask,
            buildWhen: (previous, current) =>
                current is InitUpdatePhaActualSuccessfully ||
                current is CreatePhaSuccessfully ||
                current is PhaActualLoading ||
                current is UpdatePhaSuccessfully ||
                current is InitAddPhaActualSuccessfully,
            builder: (context, state) {
              if (state is InitAddPhaActualSuccessfully) {
                List<String> phList = toList(state.phList);
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
                                                text:"Day of month",
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
                                        55 /
                                        100,
                                    child: textFormField(
                                        onChangeDayTextField,
                                        "Type the number of day in month ...",
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
                                  Text("Is short list"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: slValue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        slValue = value;
                                        if (value == false) {
                                          actualTask.add(InitPhaActualAdd());
                                        } else {
                                          actualTask
                                              .add(InitPhaActualAddShort());
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
                                                text:"Pharmacys",
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
                                      phList,
                                      "Choose a pharmacy ...",
                                      (value) {
                                        setState(() {
                                          ListItemModel pha = state.phList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          phaId = pha.id;
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
                                  Text("Priod"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(context, _selectedItem, "Priod",
                                      _dropdownMenuItems, onChangeDropdownItem),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Is Important"),
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
                                  if (_formKey.currentState.validate()) {
                                    if (phaId == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "Pharmacy Field Is Required",
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
                                          phaId,
                                          null,
                                          day,
                                          isImportant,
                                          note,
                                          _selectedItem == null
                                              ? null
                                              : _selectedItem.id,null);
                                      actualTask.add(CreatePhaActual(task));
                                    }
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is InitUpdatePhaActualSuccessfully) {
                Future.delayed(Duration.zero, () async {
                  if (isChanged == false) {
                    if (_dropdownMenuItems == null)
                      _dropdownMenuItems = buildDropdownMenuItems(state.prList);
                    setState(() {
                      phaId = state.pha.pharmacyId;
                      note = state.pha.visitNote;
                      isImportant = state.pha.important;
                      slValue = state.pha.isShortList;
                      _selectedItem = _dropdownMenuItems
                          .firstWhere((element) =>
                              element.value.id == state.pha.periodId)
                          .value;
                    });
                    isChanged = true;
                  }
                });
                List<String> phList = toList(state.phList);
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
                                                text:"Day of month",
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
                                        55 /
                                        100,
                                    child: textFormField(
                                        onChangeDayTextField,
                                        "Type the number of day in month ...",
                                        true,
                                        TextInputType.number,
                                        false,
                                        1,
                                        state.pha.day.toString()),
                                  ),
                                ]),
                                delay: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Is short list"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: slValue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        slValue = value;
                                        if (value == false) {
                                          actualTask.add(InitPhaActualUpdate(
                                              widget.task.id));
                                        } else {
                                          actualTask.add(
                                              InitPhaActualUpdateShort(
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
                                                text:"Pharmacies",
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
                                          text: widget.task.title),
                                      phList,
                                      "Choose a pharmacy ...",
                                      (value) {
                                        setState(() {
                                          ListItemModel pha = state.phList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          phaId = pha.id;
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
                                  Text("Priod"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  dropdown(context, _selectedItem, "Priod",
                                      _dropdownMenuItems, onChangeDropdownItem),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DelayedAnimation(
                                child: Row(children: <Widget>[
                                  Text("Is Important"),
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
                                        state.pha.visitNote),
                                  ),
                                ]),
                                delay: 100,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              DelayedAnimation(
                                child: button("Submit", () {
                                  if (_formKey.currentState.validate()) {
                                    if (phaId == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "Phyarmacy Field Is Required",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      if (day == null)
                                        setState(() {
                                          day = state.pha.day;
                                        });
                                      ActualModel task = new ActualModel(
                                          widget.task.id,
                                          widget.monthId,
                                          null,
                                          slValue,
                                          phaId,
                                          null,
                                          day,
                                          isImportant,
                                          note,
                                          _selectedItem == null
                                              ? null
                                              : _selectedItem.id,null);
                                      actualTask.add(UpdatePhaActual(task));
                                    }
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is CreatePhaSuccessfully) {
                if (state.check) {
                Future.delayed(Duration.zero, () async {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "تنبيه : هذا اليوم يوم عطلة ",
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
              } else if (state is UpdatePhaSuccessfully) {
                if (state.check) {
                Future.delayed(Duration.zero, () async {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "تنبيه : هذا اليوم يوم عطلة ",
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
              } else if (state is PhaActualLoading) {
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
