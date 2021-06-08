import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/API/Project/Project.dart';
import 'package:template/Bloc/Project/bloc/planned_bloc.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Screens/Project/PlannedReport.dart';
import 'package:template/Screens/Project/PlannedTask.dart';
import 'package:template/Widgets/Project/Drawer.dart';
import 'package:template/Widgets/General/List.dart';
import 'package:template/Widgets/Project/Calender.dart';

class PlannedTasks extends StatefulWidget {
  final int month, year, id;
  PlannedTasks(this.month, this.year, this.id);
  @override
  _PlannedTasks createState() => _PlannedTasks();
}

class _PlannedTasks extends State<PlannedTasks> {
  dynamic Function(DateTime date, List<Event> events) onDayPressed;
  dynamic Function(DateTime date) onDayLongPressed;
  List<Event> _events = new List();
  String error;
  var plannedTasksBloc;
  @override
  void initState() {
    super.initState();
    plannedTasksBloc = new PlannedBloc();
    plannedTasksBloc.add(GetPlannedTasks(widget.id));
    setState(() {
      this.onDayPressed =
          (date, events) => plannedTasksBloc.add(GetDayTasks(date, widget.id));
      this.onDayLongPressed = (date) => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  PlannedTask(date, widget.id, false, null, plannedTasksBloc)));
    });
  }

  Widget iconBuilder() {
    return CircleAvatar(
      backgroundColor: Color.fromRGBO(7, 163, 163, 1),
      child: Icon(Icons.timer),
    );
  }

  updateTask(ListItemModel task) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlannedTask(null, widget.id, true, task, plannedTasksBloc)));
  }

  deleteTask(int id, String type) {
    plannedTasksBloc.add(DeletePlannedTask(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.chartBar),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PlannedReport(widget.id))),
          ),
        ],
        title: Text(
          'Planned Tasks',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<PlannedBloc, PlannedState>(
        cubit: plannedTasksBloc,
        listenWhen: (previous, current) =>
            current is PlannedLoading ||
            current is DeletePlannedSuccessfully ||
            current is GetPlannedTasksSuccessfully ||
            current is PlannedTaskError ||
            current is GetPlannedTasksError,
        listener: (context, state) {
          if (state is GetPlannedTasksError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          } else if (state is PlannedTaskError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<PlannedBloc, PlannedState>(
          cubit: plannedTasksBloc,
          buildWhen: (previous, current) =>
              current is PlannedLoading ||
              current is GetPlannedTasksSuccessfully ||
              current is DeletePlannedSuccessfully ||
              current is GetDayPlannedTasksSuccessfully ||
              current is GetPlannedTasksError,
          builder: (context, state) {
            if (state is PlannedLoading) {
              return Column(
                children: [
                  viewCalender(new DateTime(widget.year, widget.month, 1),
                      onDayPressed, onDayLongPressed, _events, iconBuilder()),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            } else if (state is GetPlannedTasksSuccessfully) {
              Timer(
                Duration(milliseconds: 200),
                () => setState(() {
                  _events = state.list;
                }),
              );
              return Column(
                children: [
                  viewCalender(
                      new DateTime(widget.year, widget.month, 1),
                      onDayPressed,
                      onDayLongPressed,
                      state.list,
                      iconBuilder()),
                  Container()
                ],
              );
            } else if (state is GetDayPlannedTasksSuccessfully) {
              return Column(children: [
                viewCalender(new DateTime(widget.year, widget.month, 1),
                    onDayPressed, onDayLongPressed, _events, iconBuilder()),
                Container(
                    height: MediaQuery.of(context).size.height - 430,
                    width: MediaQuery.of(context).size.width,
                    child:
                        viewList(state.list, deleteTask, updateTask, (_) => []))
              ]);
            } else if (state is DeletePlannedSuccessfully) {
              plannedTasksBloc.add(GetPlannedTasks(widget.id));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
