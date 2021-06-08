import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/planned_bloc.dart';
import 'package:template/Models/Project/DropdownItemModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/PlanningTaskModel.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/AutoCompleteTextField.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/Dropdown.dart';

class PlannedTask extends StatefulWidget {
  final DateTime day;
  final int monthId;
  final PlannedBloc bloc;
  final bool isUpdate;
  final ListItemModel task;
  PlannedTask(this.day, this.monthId, this.isUpdate, this.task, this.bloc);
  @override
  _PlannedTask createState() => _PlannedTask();
}

class _PlannedTask extends State<PlannedTask> {
  var plannedBloc;
  List<DropDownListItem> _taskTypes = DropDownListItem.getTaskTypes();
  List<DropdownMenuItem<DropDownListItem>> _dropdownMenuItems;
  DropDownListItem _selectedItem;
  bool pha_slValue;
  bool phy_slValue;
  bool hos_slValue;

  int phyId, empId, phaId, hosId, otherId;

  @override
  void initState() {
    super.initState();
    plannedBloc = new PlannedBloc();
    if (widget.isUpdate == false) {
      plannedBloc.add(InitAddPlannedTask());
    }
    if (widget.isUpdate == true) {
      plannedBloc.add(InitUpdatePlannedTask(widget.task.id));
    }

    if (_dropdownMenuItems == null)
      _dropdownMenuItems = buildDropdownMenuItems(_taskTypes);
    _selectedItem = null;
    pha_slValue = false;
    phy_slValue = false;
    hos_slValue = false;
  }

  List<DropdownMenuItem<DropDownListItem>> buildDropdownMenuItems(
      List _taskTypes) {
    List<DropdownMenuItem<DropDownListItem>> items = List();
    for (DropDownListItem _taskType in _taskTypes) {
      items.add(
        DropdownMenuItem(
          value: _taskType,
          child: Text(_taskType.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(DropDownListItem selectedItem) {
    setState(() {
      _selectedItem = selectedItem;
    });
    switch (selectedItem.id) {
      case 1:
        plannedBloc.add(InitAddPhysician());
        break;
      case 2:
        plannedBloc.add(InitAddPharmacy());
        break;
      case 3:
        plannedBloc.add(InitAddHospital());
        break;
      case 4:
        plannedBloc.add(InitAddCoaching());
        break;
      case 5:
        plannedBloc.add(InitAddOtherTask());
        break;
      case 6:
        plannedBloc.add(InitAddVacation());
        break;
    }
  }

  onChangeDropdownItem_short(DropDownListItem selectedItem) {
    switch (selectedItem.id) {
      case 1:
        plannedBloc.add(InitAddPhysicianShort());
        break;
      case 2:
        plannedBloc.add(InitAddPharmacyShort());
        break;
      case 3:
        plannedBloc.add(InitAddHospitalShort());
        break;
    }
  }

  onChangeDropdownItemUpdate(DropDownListItem selectedItem) {
    setState(() {
      _selectedItem = selectedItem;
    });
    switch (selectedItem.id) {
      case 1:
        plannedBloc.add(InitUpdatePhysician());
        break;
      case 2:
        plannedBloc.add(InitUpdatePharmacy());
        break;
      case 3:
        plannedBloc.add(InitUpdateHospital());
        break;
      case 4:
        plannedBloc.add(InitUpdateCoaching());
        break;
      case 5:
        plannedBloc.add(InitUpdateOtherTask());
        break;
      case 6:
        plannedBloc.add(InitUpdateVacation());
        break;
    }
  }

  onChangeDropdownItemUpdate_short(DropDownListItem selectedItem) {
    switch (selectedItem.id) {
      case 1:
        plannedBloc.add(InitUpdatePhysicianShort());
        break;
      case 2:
        plannedBloc.add(InitUpdatePharmacyShort());
        break;
      case 3:
        plannedBloc.add(InitUpdateHospitalShort());
        break;
    }
  }

  createPlannedTask(String type, int monthId, int phyId, int phaId, int hosId,
      int empId, int otherId, DateTime date, bool isSL) {
    var task = new PlanningTaskModel(
        null, monthId, empId, hosId, isSL, otherId, phaId, phyId, date, type);
    plannedBloc.add(CreatePlanningTask(task));
  }

  updatePlannedTask(int id, String type, int monthId, int phyId, int phaId,
      int hosId, int empId, int otherId, DateTime date, bool isSL) {
    var task = new PlanningTaskModel(
        id, monthId, empId, hosId, isSL, otherId, phaId, phyId, date, type);
    plannedBloc.add(UpdatePlanningTask(task));
  }

  mapTaskType(String title, List<DropdownMenuItem<DropDownListItem>> list) {
    switch (title) {
      case "PhysicianVisit":
        plannedBloc.add(InitUpdatePhysician());
        setState(() {
          _selectedItem = list[0].value;
        });
        break;
      case "HospitalVisit":
        plannedBloc.add(InitUpdateHospital());
        setState(() {
          _selectedItem = list[2].value;
        });

        break;
      case "PharmacyVisit":
        plannedBloc.add(InitUpdatePharmacy());
        setState(() {
          _selectedItem = list[1].value;
        });

        break;
      case "Coaching":
        plannedBloc.add(InitUpdateCoaching());
        setState(() {
          _selectedItem = list[3].value;
        });

        break;
      case "OtherTask":
        plannedBloc.add(InitUpdateOtherTask());
        setState(() {
          _selectedItem = list[4].value;
        });
        break;
      case "Vacation":
        plannedBloc.add(InitUpdateVacation());
        setState(() {
          _selectedItem = list[5].value;
        });
        break;
    }
  }

  List<String> toList(List<ListItemModel> _list) {
    var list = new List<String>();
    for (var i = 0; i < _list.length; i++) {
      list.add(_list[i].title);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planned Task',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<PlannedBloc, PlannedState>(
        cubit: plannedBloc,
        listenWhen: (previous, current) => current is PlannedTaskError,
        listener: (context, state) {
          if (state is PlannedTaskError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
            if (widget.isUpdate == false) {
              plannedBloc.add(InitAddPlannedTask());
            }
            if (widget.isUpdate == true) {
              plannedBloc.add(InitUpdatePlannedTask(widget.task.id));
            }
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<PlannedBloc, PlannedState>(
            cubit: plannedBloc,
            buildWhen: (previous, current) =>
                current is InitAddPlannedSuccessfully ||
                current is PlannedLoading ||
                current is AddPlannedSuccessfully ||
                current is InitAddPhysicianSuccessfully ||
                current is InitAddPharmacySuccessfully ||
                current is InitAddHospitalSuccessfully ||
                current is InitAddCoachingSuccessfully ||
                current is InitAddOtherTaskSuccessfully ||
                current is InitAddVacationSuccessfully ||
                current is InitUpdatePhysicianSuccessfully ||
                current is InitUpdatePharmacySuccessfully ||
                current is InitUpdateHospitalSuccessfully ||
                current is InitUpdateCoachingSuccessfully ||
                current is InitUpdateOtherTaskSuccessfully ||
                current is InitUpdateVacationSuccessfully ||
                current is InitUpdatePlannedSuccessfully,
            // ignore: missing_return
            builder: (context, state) {
              if (state is InitAddPlannedSuccessfully ||
                  state is AddPlannedSuccessfully ||
                  state is InitAddPhysicianSuccessfully ||
                  state is InitAddPharmacySuccessfully ||
                  state is InitAddHospitalSuccessfully ||
                  state is InitAddCoachingSuccessfully ||
                  state is InitAddOtherTaskSuccessfully ||
                  state is InitAddVacationSuccessfully) {
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
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            DelayedAnimation(
                              child: Row(children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                      text: "Task Type",
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyle(color: Colors.red))
                                      ]),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                dropdown(context, _selectedItem, "Task Type",
                                    _dropdownMenuItems, onChangeDropdownItem),
                              ]),
                              delay: 100,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<PlannedBloc, PlannedState>(
                              cubit: plannedBloc,
                              buildWhen: (previous, current) =>
                                  current is PlannedLoading ||
                                  current is AddPlannedSuccessfully ||
                                  current is InitAddPhysicianSuccessfully ||
                                  current is InitAddPharmacySuccessfully ||
                                  current is InitAddHospitalSuccessfully ||
                                  current is InitAddCoachingSuccessfully ||
                                  current is InitAddOtherTaskSuccessfully ||
                                  current is InitAddVacationSuccessfully,
                              builder: (context, state) {
                                if (state is PlannedLoading) {
                                  return CircularProgressIndicator();
                                }
                                if (state is InitAddPhysicianSuccessfully) {
                                  List<String> list = toList(state.list);
                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          Text("Is short list"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Checkbox(
                                            value: phy_slValue,
                                            onChanged: (bool value) {
                                              setState(() {
                                                phy_slValue = value;
                                                var phy = new DropDownListItem(
                                                    1, "phy");
                                                if (value == false) {
                                                  plannedBloc
                                                      .add(InitAddPhysician());
                                                } else {
                                                  onChangeDropdownItem_short(
                                                      phy);
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
                                                text: "Physicians",
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                60 /
                                                100,
                                            child: autoCompleteTextField(
                                              new TextEditingController(),
                                              list,
                                              "Choose a physician ...",
                                              (value) {
                                                setState(() {
                                                  ListItemModel phy = state.list
                                                      .firstWhere((element) =>
                                                          element.title ==
                                                          value);
                                                  phyId = phy.id;
                                                });
                                              },
                                            ),
                                          )
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => createPlannedTask(
                                                "PhysicianVisit",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                phy_slValue)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitAddPharmacySuccessfully) {
                                  var list = toList(state.list);
                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          Text("Is short list"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Checkbox(
                                            value: pha_slValue,
                                            onChanged: (bool value) {
                                              setState(() {
                                                pha_slValue = value;
                                                var pha = new DropDownListItem(
                                                    2, "pha");
                                                if (value == false) {
                                                  plannedBloc
                                                      .add(InitAddPharmacy());
                                                } else {
                                                  onChangeDropdownItem_short(
                                                      pha);
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
                                                text: "Pharmacies",
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  60 /
                                                  100,
                                              child: autoCompleteTextField(
                                                  new TextEditingController(),
                                                  list,
                                                  "Choose a pharmacy ...",
                                                  (value) {
                                                setState(() {
                                                  ListItemModel pha = state.list
                                                      .firstWhere((element) =>
                                                          element.title ==
                                                          value);
                                                  phaId = pha.id;
                                                });
                                              })),
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => createPlannedTask(
                                                "PharmacyVisit",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                pha_slValue)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitAddHospitalSuccessfully) {
                                  var list = toList(state.list);
                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          Text("Is short list"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Checkbox(
                                            value: hos_slValue,
                                            onChanged: (bool value) {
                                              setState(() {
                                                hos_slValue = value;
                                                var hos = new DropDownListItem(
                                                    3, "hos");
                                                if (value == false) {
                                                  plannedBloc
                                                      .add(InitAddHospital());
                                                } else {
                                                  onChangeDropdownItem_short(
                                                      hos);
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
                                                text: "Hospitals",
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                60 /
                                                100,
                                            child: autoCompleteTextField(
                                                new TextEditingController(),
                                                list,
                                                "Choose a hospital ...",
                                                (value) {
                                              setState(() {
                                                ListItemModel hos = state.list
                                                    .firstWhere((element) =>
                                                        element.title == value);
                                                hosId = hos.id;
                                              });
                                            }),
                                          ),
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => createPlannedTask(
                                                "HospitalVisit",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                hos_slValue)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitAddCoachingSuccessfully) {
                                  var list = toList(state.list);

                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          RichText(
                                            text: TextSpan(
                                                text: "Employees",
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                60 /
                                                100,
                                            child: autoCompleteTextField(
                                                new TextEditingController(),
                                                list,
                                                "Choose an Employee ...",
                                                (value) {
                                              setState(() {
                                                ListItemModel emp = state.list
                                                    .firstWhere((element) =>
                                                        element.title == value);
                                                empId = emp.id;
                                              });
                                            }),
                                          ),
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => createPlannedTask(
                                                "Coaching",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                false)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitAddOtherTaskSuccessfully) {
                                  var list = toList(state.list);

                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          RichText(
                                            text: TextSpan(
                                                text: "Other Task",
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                60 /
                                                100,
                                            child: autoCompleteTextField(
                                                new TextEditingController(),
                                                list,
                                                "Choose a Task ...", (value) {
                                              setState(() {
                                                ListItemModel other = state.list
                                                    .firstWhere((element) =>
                                                        element.title == value);
                                                otherId = other.id;
                                              });
                                            }),
                                          ),
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => createPlannedTask(
                                                "OtherTask",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                false)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitAddVacationSuccessfully) {
                                  return Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => createPlannedTask(
                                                "Vacation",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                false)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                }

                                if (state is AddPlannedSuccessfully) {
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
                                  widget.bloc
                                      .add(GetPlannedTasks(widget.monthId));
                                      });} else {
                  Navigator.of(context).pop();
                  widget.bloc.add(GetPlannedTasks(widget.monthId));
                }
                                }
                                return Container();
                              },
                            ),
                          ]),
                        )));
              } else if (state is InitUpdatePlannedSuccessfully ||
                  state is InitUpdatePhysicianSuccessfully ||
                  state is InitUpdatePharmacySuccessfully ||
                  state is InitUpdateHospitalSuccessfully ||
                  state is InitUpdateCoachingSuccessfully ||
                  state is PlannedLoading ||
                  state is InitUpdateOtherTaskSuccessfully ||
                  state is InitUpdateVacationSuccessfully) {
                if (state is InitUpdatePlannedSuccessfully) {
                  mapTaskType(state.task.taskType, _dropdownMenuItems);
                  setState(() {
                    empId = state.task.employeeId;
                    phyId = state.task.physicianId;
                    phaId = state.task.pharmacyId;
                    hosId = state.task.hospitalId;
                    otherId = state.task.otherTaskTypeId;
                    switch (state.task.taskType) {
                      case "PhysicianVisit":
                        phy_slValue = state.task.isShortList;

                        break;
                      case "HospitalVisit":
                        hos_slValue = state.task.isShortList;

                        break;
                      case "PharmacyVisit":
                        pha_slValue = state.task.isShortList;

                        break;
                    }
                  });
                  Timer(Duration(milliseconds: 500), () {});
                }
                return BlocBuilder<PlannedBloc, PlannedState>(
                  cubit: plannedBloc,
                  builder: (context, _state) {
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
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            DelayedAnimation(
                              child: Row(children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                      text: "Task Type",
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyle(color: Colors.red))
                                      ]),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                dropdown(
                                    context,
                                    _selectedItem,
                                    "Task Type",
                                    _dropdownMenuItems,
                                    onChangeDropdownItemUpdate),
                              ]),
                              delay: 100,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<PlannedBloc, PlannedState>(
                              cubit: plannedBloc,
                              buildWhen: (previous, current) =>
                                  current is PlannedLoading ||
                                  current is UpdatePlannedSuccessfully ||
                                  current is InitUpdatePhysicianSuccessfully ||
                                  current is InitUpdatePharmacySuccessfully ||
                                  current is InitUpdateHospitalSuccessfully ||
                                  current is InitUpdateCoachingSuccessfully ||
                                  current is InitUpdateOtherTaskSuccessfully ||
                                  current is InitUpdateVacationSuccessfully,
                              builder: (context, state) {
                                if (state is InitUpdatePhysicianSuccessfully) {
                                  List<String> list = toList(state.list);
                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          Text("Is short list"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Checkbox(
                                            value: phy_slValue,
                                            onChanged: (bool value) {
                                              setState(() {
                                                phy_slValue = value;
                                                var phy = new DropDownListItem(
                                                    1, "phy");
                                                if (value == false) {
                                                  plannedBloc.add(
                                                      InitUpdatePhysician());
                                                } else {
                                                  onChangeDropdownItemUpdate_short(
                                                      phy);
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
                                                text: "Physicians",
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                60 /
                                                100,
                                            child: autoCompleteTextField(
                                              new TextEditingController(
                                                  text: widget.task.title),
                                              list,
                                              "Choose a physician ...",
                                              (value) {
                                                setState(() {
                                                  ListItemModel phy = state.list
                                                      .firstWhere((element) =>
                                                          element.title ==
                                                          value);
                                                  phyId = phy.id;
                                                });
                                              },
                                            ),
                                          )
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => updatePlannedTask(
                                                widget.task.id,
                                                "PhysicianVisit",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                phy_slValue)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitUpdatePharmacySuccessfully) {
                                  var list = toList(state.list);
                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          Text("Is short list"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Checkbox(
                                            value: pha_slValue,
                                            onChanged: (bool value) {
                                              setState(() {
                                                pha_slValue = value;
                                                var pha = new DropDownListItem(
                                                    2, "pha");
                                                if (value == false) {
                                                  plannedBloc.add(
                                                      InitUpdatePharmacy());
                                                } else {
                                                  onChangeDropdownItemUpdate_short(
                                                      pha);
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
                                                text: "Pharmacies",
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  60 /
                                                  100,
                                              child: autoCompleteTextField(
                                                  new TextEditingController(
                                                      text: widget.task.title),
                                                  list,
                                                  "Choose a pharmacy ...",
                                                  (value) {
                                                setState(() {
                                                  ListItemModel pha = state.list
                                                      .firstWhere((element) =>
                                                          element.title ==
                                                          value);
                                                  phaId = pha.id;
                                                });
                                              })),
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => updatePlannedTask(
                                                widget.task.id,
                                                "PharmacyVisit",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                pha_slValue)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitUpdateHospitalSuccessfully) {
                                  var list = toList(state.list);
                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          Text("Is short list"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Checkbox(
                                            value: hos_slValue,
                                            onChanged: (bool value) {
                                              setState(() {
                                                hos_slValue = value;
                                                var hos = new DropDownListItem(
                                                    3, "hos");
                                                if (value == false) {
                                                  plannedBloc.add(
                                                      InitUpdateHospital());
                                                } else {
                                                  onChangeDropdownItemUpdate_short(
                                                      hos);
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
                                                text: "Hospitals",
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                60 /
                                                100,
                                            child: autoCompleteTextField(
                                                new TextEditingController(
                                                    text: widget.task.title),
                                                list,
                                                "Choose a hospital ...",
                                                (value) {
                                              setState(() {
                                                ListItemModel hos = state.list
                                                    .firstWhere((element) =>
                                                        element.title == value);
                                                hosId = hos.id;
                                              });
                                            }),
                                          ),
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => updatePlannedTask(
                                                widget.task.id,
                                                "HospitalVisit",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                hos_slValue)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitUpdateCoachingSuccessfully) {
                                  var list = toList(state.list);

                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          RichText(
                                            text: TextSpan(
                                                text: "Employees",
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                60 /
                                                100,
                                            child: autoCompleteTextField(
                                                new TextEditingController(
                                                    text: widget.task.title),
                                                list,
                                                "Choose an Employee ...",
                                                (value) {
                                              setState(() {
                                                ListItemModel emp = state.list
                                                    .firstWhere((element) =>
                                                        element.title == value);
                                                empId = emp.id;
                                              });
                                            }),
                                          ),
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => updatePlannedTask(
                                                widget.task.id,
                                                "Coaching",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                false)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitUpdateOtherTaskSuccessfully) {
                                  var list = toList(state.list);

                                  return Column(
                                    children: <Widget>[
                                      DelayedAnimation(
                                        child: Row(children: <Widget>[
                                          RichText(
                                            text: TextSpan(
                                                text: "Other Task",
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                60 /
                                                100,
                                            child: autoCompleteTextField(
                                                new TextEditingController(
                                                    text: widget.task.title),
                                                list,
                                                "Choose a Task ...", (value) {
                                              setState(() {
                                                ListItemModel other = state.list
                                                    .firstWhere((element) =>
                                                        element.title == value);
                                                otherId = other.id;
                                              });
                                            }),
                                          ),
                                        ]),
                                        delay: 200,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => updatePlannedTask(
                                                widget.task.id,
                                                "OtherTask",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                false)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                } else if (state
                                    is InitUpdateVacationSuccessfully) {
                                  return Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      DelayedAnimation(
                                        child: button(
                                            "Submit",
                                            () => updatePlannedTask(
                                                widget.task.id,
                                                "Vacation",
                                                widget.monthId,
                                                phyId,
                                                phaId,
                                                hosId,
                                                empId,
                                                otherId,
                                                widget.day,
                                                false)),
                                        delay: 200,
                                      )
                                    ],
                                  );
                                }

                                if (state is UpdatePlannedSuccessfully) {
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
                                  widget.bloc
                                      .add(GetPlannedTasks(widget.monthId));
                                      });} else {
                  Navigator.of(context).pop();
                  widget.bloc.add(GetPlannedTasks(widget.monthId));
                }
                                }

                                if (state is PlannedLoading) {
                                  return CircularProgressIndicator();
                                }
                                return Container();
                              },
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
