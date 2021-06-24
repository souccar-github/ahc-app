import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/actual_bloc.dart';
import 'package:template/Bloc/Project/bloc/otheractualtask_bloc.dart';
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

class OtherActualTask extends StatefulWidget {
  final int monthId;
  final bool isUpdate;
  final ActualBloc bloc;
  final ListItemModel task;
  OtherActualTask(this.monthId, this.isUpdate, this.task, this.bloc);
  @override
  _OtherActualTask createState() => _OtherActualTask();
}

class _OtherActualTask extends State<OtherActualTask> {
  var actualTask;
  int otherId, day;
  final _formKey = new GlobalKey<FormState>();
  String note;
  List<DropdownMenuItem<DropDownListItem>> _dropdownMenuItems;
  bool  isImportant, isChanged;

  @override
  void initState() {
    actualTask = new OtheractualtaskBloc();
    if (widget.isUpdate == false) {
      actualTask.add(InitOtherActualAdd(null));
    }
    if (widget.isUpdate == true) {
      actualTask.add(InitOtherActualUpdate(widget.task.id, null));
    }
    isChanged = false;
    isImportant = false;
    super.initState();
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
          Localization.of(context).getTranslatedValue("OtherActualTask"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<OtheractualtaskBloc, OtheractualtaskState>(
        cubit: actualTask,
        listenWhen: (previous, current) => current is OtherActualError,
        listener: (context, state) {
          if (state is OtherActualError) {
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
          child: BlocBuilder<OtheractualtaskBloc, OtheractualtaskState>(
            cubit: actualTask,
            buildWhen: (previous, current) =>
                current is CreateOtherSuccessfully ||
                current is UpdateOtherSuccessfully ||
                current is InitUpdateOtherActualSuccessfully ||
                current is OtherActualLoading ||
                current is InitAddOtherActualSuccessfully,
            builder: (context, state) {
              if (state is InitAddOtherActualSuccessfully) {
                List<String> otherList = toList(state.otherList);
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
                                                text: Localization.of(context).getTranslatedValue("DayofMonth"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ))
                                                ]),
                                          ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        57 /
                                        100,
                                    child: textFormField(
                                        onChangeDayTextField,
                                        Localization.of(context).getTranslatedValue("Typethenumberofdayinmonth"),
                                        true,
                                        TextInputType.number,
                                        false,
                                        1,
                                        state.day?.toString() ?? ""),
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
                                                text: Localization.of(context).getTranslatedValue("Othertasks"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ))
                                                ]),
                                          ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        57 /
                                        100,
                                    child: autoCompleteTextField(
                                      new TextEditingController(),
                                      otherList,
                                      Localization.of(context).getTranslatedValue("Chooseanothertask"),
                                      (value) {
                                        setState(() {
                                          ListItemModel other = state.otherList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          otherId = other.id;
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
                                isImportant?RichText(
                                            text: TextSpan(
                                                text: Localization.of(context).getTranslatedValue("Note"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ))
                                                ]),
                                          )
                                          :  Text(Localization.of(context).getTranslatedValue("Note")),
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
                                    if (otherId == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          Localization.of(context).getTranslatedValue("OtherTaskFieldIsRequired"),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      ActualModel task = new ActualModel(
                                          null,
                                          widget.monthId,
                                          null,
                                          false,
                                          null,
                                          null,
                                          day,
                                          isImportant,
                                          note,
                                          null,
                                          otherId);
                                      actualTask.add(CreateOtherActual(task));
                                    }
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is InitUpdateOtherActualSuccessfully) {
                Future.delayed(Duration.zero, () async {
                  if (isChanged == false) {
                    setState(() {
                      otherId = state.other.otherId;
                      isImportant = state.other.important;
                      note = state.other.visitNote;
                    });
                    isChanged = true;
                  }
                });
                List<String> otherList = toList(state.otherList);
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
                                                text: Localization.of(context).getTranslatedValue("DayofMonth"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ))
                                                ]),
                                          ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        57 /
                                        100,
                                    child: textFormField(
                                        onChangeDayTextField,
                                        Localization.of(context).getTranslatedValue("Typethenumberofdayinmonth"),
                                        true,
                                        TextInputType.number,
                                        false,
                                        1,
                                        state.other.day.toString()),
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
                                                text: Localization.of(context).getTranslatedValue("Othertasks"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ))
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
                                          text: widget.task.body),
                                      otherList,
                                      Localization.of(context).getTranslatedValue("Chooseaothertask"),
                                      (value) {
                                        setState(() {
                                          ListItemModel other = state.otherList
                                              .firstWhere((element) =>
                                                  element.title == value);
                                          otherId = other.id;
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
                                 isImportant? RichText(
                                            text: TextSpan(
                                                text: Localization.of(context).getTranslatedValue("Note"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ))
                                                ]),
                                          ): Text(Localization.of(context).getTranslatedValue("Note")),
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
                                        state.other.visitNote),
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
                                    if (otherId == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          Localization.of(context).getTranslatedValue("OtherFieldIsRequired"),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      if (day == null)
                                        setState(() {
                                          day = state.other.day;
                                        });
                                      ActualModel task = new ActualModel(
                                          widget.task.id,
                                          widget.monthId,
                                          null,
                                          false,
                                          null,
                                          null,
                                          day,
                                          isImportant,
                                          note,
                                          null,
                                          otherId);
                                      actualTask.add(UpdateOtherActual(task));
                                    }
                                  }
                                }),
                                delay: 200,
                              )
                            ]),
                          ),
                        )));
              } else if (state is UpdateOtherSuccessfully) {
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
              } else if (state is CreateOtherSuccessfully) {
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
              } else if (state is OtherActualLoading) {
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
