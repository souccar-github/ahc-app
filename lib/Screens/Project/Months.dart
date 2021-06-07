import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:template/Bloc/Project/bloc/month_bloc.dart';
import 'package:template/Models/Project/MonthModel.dart';
import 'package:template/Screens/Project/ActualTasks.dart';
import 'package:template/Screens/Project/PlannedTasks.dart';
import 'package:template/Widgets/General/Drawer.dart';

class Months extends StatefulWidget {
  @override
  _Months createState() => _Months();
}

class _Months extends State<Months> {
  GlobalKey btnKey = GlobalKey();
  MonthBloc monthBloc;
  var months = new List<MonthModel>();
  @override
  void initState() {
    super.initState();
    monthBloc = new MonthBloc();
    monthBloc.add(GetMonths());
  }

  @override
  Widget build(BuildContext context) {
    final Size sizeAware = MediaQuery.of(context).size;
    return new Scaffold(
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showMonthPicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 3, 1),
            lastDate: DateTime(DateTime.now().year + 3, 12),
            initialDate: DateTime.now(),
          ).then((date) {
            if (date != null) {
              monthBloc.add(AddNewMonth(date.year, date.month));
            }
          });
        },
      ),
      appBar: AppBar(
        title: Text(
          'Months',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<MonthBloc, MonthState>(
        cubit: monthBloc,
        listenWhen: (previous, current) => current is MonthsError,
        listener: (context, state) {
          if (state is MonthsError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<MonthBloc, MonthState>(
          cubit: monthBloc,
          buildWhen: (previous, current) =>
              current is MonthsGetSuccessfully ||
              current is MonthsLoading ||
              current is MonthDeletedSuccessfully ||
              current is MonthAddedSuccessfully,
          // ignore: missing_return
          builder: (context, state) {
            if (state is MonthDeletedSuccessfully ||
                state is MonthAddedSuccessfully) {
              monthBloc.add(GetMonths());
            } else if (state is MonthsGetSuccessfully) {
              Timer(
                  new Duration(milliseconds: 300),
                  () => setState(() {
                        months = state.months;
                      }));
              return ListView.builder(
                itemCount: months.length,
                itemBuilder: (context, index) => Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                          child: Icon(
                        Icons.date_range,
                      )),
                      title: Text('${months[index].NameForDropdown}'),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => monthBloc.add(DeleteMonth(months[index].Id)),
                    ),
                    IconSlideAction(
                      caption: 'Update',
                      color: Colors.orange,
                      icon: Icons.update,
                      onTap: () => showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 3, 1),
                        lastDate: DateTime(DateTime.now().year + 3, 12),
                        initialDate: new DateTime(
                            months[index].Year, months[index].MonthNumber),
                      ).then((date) {
                        if (date != null) {
                          monthBloc.add(UpdateMonth(
                              date.year, date.month, months[index].Id));
                        }
                      }),
                    ),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      key: btnKey,
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                            value: 'Planning Tasks',
                            child: ListTile(
                              title: Text("Planning Tasks"),
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) => PlannedTasks(
                                            months[index].MonthNumber,
                                            months[index].Year,
                                            months[index].Id)));
                              },
                              leading: Icon(Icons.timer),
                            )),
                        PopupMenuItem<String>(
                            value: 'Actual Tasks',
                            child: ListTile(
                              title: Text("Actual Tasks"),
                              onTap: () {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                    builder: (context) => ActualTasks(
                                        months[index].MonthNumber,
                                        months[index].Year,
                                        months[index].Id),
                                  ),
                                );
                              },
                              leading: Icon(Icons.done),
                            )),
                      ],
                      onSelected: (_) {},
                    ),
                  ],
                ),
              );
            } else if (state is MonthsLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
