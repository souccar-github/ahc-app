import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:template/Bloc/Project/bloc/plannedtoactual_bloc.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Widgets/General/Animation/delayed_animation.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/MultiSelect.dart';
import 'package:smart_select/smart_select.dart';

class CopyPlannedToActual extends StatefulWidget {
  @override
  _CopyPlannedToActual createState() => _CopyPlannedToActual();
}

class _CopyPlannedToActual extends State<CopyPlannedToActual> {
  PlannedtoactualBloc bloc;
  String date;
  List<String> selectedTasks;
  @override
  void initState() {
    date = null;
    bloc = new PlannedtoactualBloc();
    selectedTasks = new List<String>();
    bloc.add(InitPlannedToActual());
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
          Localization.of(context).getTranslatedValue("CopyPlannedToActual"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<PlannedtoactualBloc, PlannedtoactualState>(
        cubit: bloc,
        listenWhen: (previous, current) => current is PlannedToActualError,
        listener: (context, state) {
          if (state is PlannedToActualError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
            bloc.add(InitPlannedToActual());
          }
        },
        child: BlocBuilder<PlannedtoactualBloc, PlannedtoactualState>(
          cubit: bloc,
          buildWhen: (previous, current) =>
              current is PlannedToActualLoading ||
              current is InitPlannedToActualSuccessfully ||
              current is InitTasksPlannedToActualSuccessfully ||
              current is PlannedToActualSubmittedSuccessfully,
          builder: (context, state) {
            if (state is PlannedToActualLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is InitPlannedToActualSuccessfully) {
              return DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'dd MMM, yyyy',
                initialValue: date ??
                    (new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                        .toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: Localization.of(context).getTranslatedValue("Date"),
                onChanged: (val) {
                  setState(() {
                    date = val;
                  });
                  bloc.add(InitTasksPlannedToActual(date));
                },
              );
            }
            if (state is InitTasksPlannedToActualSuccessfully) {
              return Column(
                children: <Widget>[
                  DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'dd MMM, yyyy',
                    initialValue: date ??
                        (new DateTime(
                                DateTime.now().year, DateTime.now().month, DateTime.now().day))
                            .toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: Localization.of(context).getTranslatedValue("Date"),
                    onChanged: (val) => setState(() {
                      date = val;
                      bloc.add(InitTasksPlannedToActual(date));
                    }),
                    onSaved: (val) => bloc.add(InitTasksPlannedToActual(val)),
                  ),
                  MultiSelect(
                      title: Localization.of(context).getTranslatedValue("PlannedTasks"),
                      selected: selectedTasks,
                      items: buildList(state.tasks),
                      icon: Icons.timer,
                      callback: (selected) => this.callback(selected)),
                  SizedBox(
                    height: 40,
                  ),
                  selectedTasks.length > 0
                      ? DelayedAnimation(
                          child: button(Localization.of(context).getTranslatedValue("Submit"), () {
                            bloc.add(
                                PlannedToActualSubmit(selectedTasks, date));
                          }),
                          delay: 200,
                        )
                      : Container()
                ],
              );
            }
            if (state is PlannedToActualSubmittedSuccessfully) {
              Timer(Duration(milliseconds: 2000),
                  () => Navigator.of(context).pop());
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  Localization.of(context).getTranslatedValue("SuccessfullySubmitted"),
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
