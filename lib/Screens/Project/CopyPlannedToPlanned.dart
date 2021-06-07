import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:template/Bloc/Project/bloc/plannedtoplanned_bloc.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/MultiSelect.dart';
import 'package:smart_select/smart_select.dart';

class CopyPlannedToPlanned extends StatefulWidget {
  @override
  _CopyPlannedToPlanned createState() => _CopyPlannedToPlanned();
}

class _CopyPlannedToPlanned extends State<CopyPlannedToPlanned> {
  PlannedtoplannedBloc bloc;
  String fromDate;
  String toDate;
  List<String> selectedTasks;
  @override
  void initState() {
    fromDate = null;
    toDate = null;
    selectedTasks = new List<String>();
    bloc = new PlannedtoplannedBloc();
    bloc.add(InitPlannedToPlanned());
    super.initState();
  }

  void callback(List<String> _selected) {
    setState(() {
      selectedTasks = _selected;
    });
  }

  List<S2Choice<String>> buildList(List<ListItemModel> list) {
    List<S2Choice<String>> _list = [];
    if (list != null)
      for (int i = 0; i < list.length; i++) {
        S2Choice<String> item = new S2Choice<String>(
            value: list[i].id.toString(),
            title: list[i].title + " - " + list[i].type);
        _list.add(item);
      }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Copy Planned To Planned',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<PlannedtoplannedBloc, PlannedtoplannedState>(
        cubit: bloc,
        listenWhen: (previous, current) => current is PlannedToPlannedError,
        listener: (context, state) {
          if (state is PlannedToPlannedError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
            bloc.add(InitPlannedToPlanned());
          }
        },
        child: BlocBuilder<PlannedtoplannedBloc, PlannedtoplannedState>(
          cubit: bloc,
          buildWhen: (previous, current) =>
              current is PlannedToPlannedLoading ||
              current is InitPlannedToPlannedSuccessfully ||
              current is InitTasksPlannedToPlannedSuccessfully ||
              current is PlannedToPlannedSubmittedSuccessfully,
          builder: (context, state) {
            if (state is PlannedToPlannedLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is InitPlannedToPlannedSuccessfully) {
              return Container(
                child: Column(
                  children: <Widget>[
                    DateTimePicker(
                      type: DateTimePickerType.date,
                      dateMask: 'dd MMM, yyyy',
                      initialValue: fromDate ?? (new DateTime(DateTime.now().year,DateTime.now().month-1,1)).toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'From Date',
                      onChanged: (val) {
                        setState(() {
                          fromDate = val;
                        });
                        if (fromDate != null && toDate != null)
                          bloc.add(InitTasksPlannedToPlanned(fromDate, toDate));
                      },
                    ),
                    DateTimePicker(
                      type: DateTimePickerType.date,
                      dateMask: 'dd MMM, yyyy',
                      initialValue: toDate ?? (new DateTime(DateTime.now().year,DateTime.now().month,1)).toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'To Date',
                      onChanged: (val) {
                        setState(() {
                          toDate = val;
                        });
                        if (fromDate != null && toDate != null)
                          bloc.add(InitTasksPlannedToPlanned(fromDate, toDate));
                      },
                    )
                  ],
                ),
              );
            }
            if (state is InitTasksPlannedToPlannedSuccessfully) {
              return Column(
                children: <Widget>[
                  DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'dd MMM, yyyy',
                    initialValue: fromDate ?? (new DateTime(DateTime.now().year,DateTime.now().month-1,1)).toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'From Date',
                    onChanged: (val) {
                      setState(() {
                        fromDate = val;
                      });
                      if (fromDate != null && toDate != null)
                        bloc.add(InitTasksPlannedToPlanned(fromDate, toDate));
                    },
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'dd MMM, yyyy',
                    initialValue: toDate ?? (new DateTime(DateTime.now().year,DateTime.now().month,1)).toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'To Date',
                    onChanged: (val) {
                      setState(() {
                        toDate = val;
                      });
                      if (fromDate != null && toDate != null)
                        bloc.add(InitTasksPlannedToPlanned(fromDate, toDate));
                    },
                  ),
                  MultiSelect(
                      title: "Planned Tasks",
                      selected: selectedTasks,
                      items: buildList(state.tasks),
                      icon: Icons.timer,
                      callback: (selected) => this.callback(selected)),
                  SizedBox(
                    height: 40,
                  ),
                  selectedTasks.length > 0
                      ? DelayedAnimation(
                          child: button("Submit", () {
                            bloc.add(
                                PlannedToPlannedSubmit(selectedTasks, toDate));
                          }),
                          delay: 200,
                        )
                      : Container()
                ],
              );
            }
            if (state is PlannedToPlannedSubmittedSuccessfully) {
               Timer(Duration(milliseconds: 2000),
                  () => Navigator.of(context).pop());
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Successfully Submitted",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ));
             
            }
            return Container();
          },
        ),
      ),
    );
  }
}
