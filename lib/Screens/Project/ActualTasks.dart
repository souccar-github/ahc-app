import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Bloc/Project/bloc/actual_bloc.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Screens/Project/Clinics.dart';
import 'package:template/Screens/Project/HospitalActualTask.dart';
import 'package:template/Screens/Project/OtherActualTask.dart';
import 'package:template/Screens/Project/PharmacyActualTask.dart';
import 'package:template/Screens/Project/PhysicianActualTask.dart';
import 'package:template/Screens/Project/Products.dart';
import 'package:template/Screens/Project/PhyProduct.dart';
import 'package:template/Screens/Project/Report.dart';
import 'package:template/Widgets/General/List.dart';
import 'package:template/Widgets/Project/Calender.dart';
import 'package:template/Widgets/Project/Drawer.dart';

class ActualTasks extends StatefulWidget {
  final int month, year, id;
  ActualTasks(this.month, this.year, this.id);
  @override
  _ActualTasks createState() => _ActualTasks();
}

class _ActualTasks extends State<ActualTasks> {
  dynamic Function(DateTime date, List<Event> events) onDayPressed;
  dynamic Function(DateTime date) onDayLongPressed;
  GlobalKey key;
  List<Event> _events = new List();
  String error;
  var actualTasksBloc;
  @override
  void initState() {
    super.initState();
    actualTasksBloc = new ActualBloc();
    actualTasksBloc.add(GetActualTasks(widget.id));
    setState(() {
      key = GlobalKey();
      onDayLongPressed = (date) => null;
      this.onDayPressed =
          (date, events) => actualTasksBloc.add(GetDayTasks(date, widget.id));
    });
  }

  deleteTask(int id, String type) {
    actualTasksBloc.add(DeleteActualTask(id, type));
  }

  List<Widget> actions(ListItemModel task) {
    if (task.type == "HospitalVisit") {
      return [
        IconSlideAction(
          caption: '',
          color: Color.fromRGBO(7, 163, 163, 1),
          icon: FontAwesomeIcons.boxes,
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Clinics(task.id))),
        )
      ];
    }
    if (task.type == "OtherTask") {
      return [];
    }
    return [
      IconSlideAction(
        caption: '',
        color: Color.fromRGBO(7, 163, 163, 1),
        icon: FontAwesomeIcons.boxes,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Products(task.type, task.id))),
      )
    ];
  }

  updateTask(ListItemModel task) {
    switch (task.type) {
      case "PhysicianVisit":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PhysicianActualTask(widget.id, true, task, actualTasksBloc)));
        break;
      case "PharmacyVisit":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PharmacyActualTask(widget.id, true, task, actualTasksBloc)));
        break;
      case "HospitalVisit":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                HospitalActualTask(widget.id, true, task, actualTasksBloc)));
        break;
      case "OtherTask":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                OtherActualTask(widget.id, true, task, actualTasksBloc)));
        break;
    }
  }

  Widget iconBuilder() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(Icons.done),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PopupMenuButton(
        icon: Icon(
          Icons.add_box,
          size: 50,
          color: Color.fromRGBO(7, 163, 163, 1),
        ),
        key: key,
        itemBuilder: (_) => <PopupMenuItem<String>>[
          PopupMenuItem<String>(
              value: 'Add Physician Visit',
              child: ListTile(
                title: Text("Add Physician Visit"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PhysicianActualTask(
                          widget.id, false, null, actualTasksBloc)));
                },
                leading: Icon(FontAwesomeIcons.stethoscope),
              )),
          PopupMenuItem<String>(
              value: 'Add Pharmacy Visit',
              child: ListTile(
                title: Text("Add Pharmacy Visit"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PharmacyActualTask(
                          widget.id, false, null, actualTasksBloc)));
                },
                leading: Icon(FontAwesomeIcons.handHoldingMedical),
              )),
          PopupMenuItem<String>(
              value: 'Add Hospital Visit',
              child: ListTile(
                title: Text("Add Hospital Visit"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HospitalActualTask(
                          widget.id, false, null, actualTasksBloc)));
                },
                leading: Icon(FontAwesomeIcons.hospital),
              )),
          PopupMenuItem<String>(
              value: 'Add Other Task',
              child: ListTile(
                title: Text("Add Other Task"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OtherActualTask(
                          widget.id, false, null, actualTasksBloc)));
                },
                leading: Icon(FontAwesomeIcons.boxes),
              )),
        ],
        onSelected: (_) {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.chartBar),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Report(widget.id))),
          ),
        ],
        title: Text(
          'Actual Tasks',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<ActualBloc, ActualState>(
        cubit: actualTasksBloc,
        listenWhen: (previous, current) =>
            current is ActualLoading ||
            current is GetActualTasksSuccessfully ||
            current is GetActualTasksError,
        listener: (context, state) {
          // TODO: implement listener
        },
        child: BlocBuilder<ActualBloc, ActualState>(
          cubit: actualTasksBloc,
          buildWhen: (previous, current) =>
              current is ActualLoading ||
              current is GetActualTasksSuccessfully ||
              current is GetDayActualTasksSuccessfully ||
              current is DeleteActualSuccessfully ||
              current is GetActualTasksError,
          builder: (context, state) {
            if (state is ActualLoading) {
              return Column(
                children: [
                  viewCalender(new DateTime(widget.year, widget.month, 1),
                      onDayPressed, null, _events, iconBuilder()),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            } else if (state is GetActualTasksSuccessfully) {
              Timer(
                Duration(milliseconds: 200),
                () => setState(() {
                  _events = state.list;
                }),
              );
              return Column(
                children: [
                  viewCalender(new DateTime(widget.year, widget.month, 1),
                      onDayPressed, null, state.list, iconBuilder()),
                  Container()
                ],
              );
            } else if (state is GetDayActualTasksSuccessfully) {
              return Column(
                children: [
                  viewCalender(new DateTime(widget.year, widget.month, 1),
                      onDayPressed, null, _events, iconBuilder()),
                  Container(
                      height: MediaQuery.of(context).size.height - 400,
                      width: MediaQuery.of(context).size.width,
                      child:
                          viewList(state.list, deleteTask, updateTask, actions))
                ],
              );
            } else if (state is DeleteActualSuccessfully) {
              actualTasksBloc.add(GetActualTasks(widget.id));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
