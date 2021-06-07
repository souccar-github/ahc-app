import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/Bloc/Project/bloc/report_bloc.dart';
import 'package:template/Bloc/Project/bloc/hosproduct_bloc.dart';
import 'package:template/Bloc/Project/bloc/phaproduct_bloc.dart';
import 'package:template/Bloc/Project/bloc/physicianproduct_bloc.dart';
import 'package:template/Models/Project/ActualVisitModel.dart';
import 'package:template/Widgets/General/Drawer.dart';
import 'package:template/Widgets/General/List.dart';

import 'Products.dart';

class Report extends StatefulWidget {
  final int id;
  Report(this.id);
  @override
  _Report createState() => _Report();
}

class _Report extends State<Report> {
  var reportBloc;
  int _selectedIndex;
  List<ActualVisitModel> report;
  @override
  void initState() {
    reportBloc = new ReportBloc();
    _selectedIndex = 0;
    reportBloc.add(GetPhysiciansReport(widget.id));
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        reportBloc.add(GetPhysiciansReport(widget.id));
        break;
      case 1:
        reportBloc.add(GetPharmaciesReport(widget.id));
        break;
      case 2:
        reportBloc.add(GetHospitalsReport(widget.id));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              activeIcon: Icon(
                FontAwesomeIcons.stethoscope,
                color: Color.fromRGBO(7, 163, 163, 1),
              ),
              icon: Icon(FontAwesomeIcons.stethoscope),
              title: Text("")),
          BottomNavigationBarItem(
              activeIcon: Icon(
                FontAwesomeIcons.handHoldingMedical,
                color: Color.fromRGBO(7, 163, 163, 1),
              ),
              icon: Icon(FontAwesomeIcons.handHoldingMedical),
              title: Text("")),
          BottomNavigationBarItem(
              activeIcon: Icon(
                FontAwesomeIcons.hospital,
                color: Color.fromRGBO(7, 163, 163, 1),
              ),
              icon: Icon(FontAwesomeIcons.hospital),
              title: Text("")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        title: Text(
          'Report',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<ReportBloc, ReportState>(
        cubit: reportBloc,
        listenWhen: (previous, current) => current is ReportError,
        listener: (context, state) {
          if (state is ReportError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<ReportBloc, ReportState>(
          cubit: reportBloc,
          buildWhen: (previous, current) =>
              current is PhysiciansReportSuccessfully ||
              current is PharmaciesReportSuccessfully ||
              current is HospitalsReportSuccessfully ||
              current is ReportLoading,
          builder: (context, state) {
            if (state is PhysiciansReportSuccessfully) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  report = state.report;
                });
              });
            } else if (state is PharmaciesReportSuccessfully) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  report = state.report;
                });
              });
            } else if (state is HospitalsReportSuccessfully) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  report = state.report;
                });
              });
            } else if (state is ReportLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
                alignment: Alignment.topLeft,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: report.length,
                    itemBuilder: (context, index) => Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.crop_square),
                                        Text("Name : ",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    7, 163, 163, 1),
                                                fontSize: 18)),
                                        Text(report[index].name,
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                    Row(children: [
                                      Icon(Icons.crop_square),
                                      Text("Address : ",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  7, 163, 163, 1),
                                              fontSize: 18)),
                                      Text(report[index].address,
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ]),
                                    Row(
                                      children: [
                                        Icon(Icons.crop_square),
                                        Text("Rating : ",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    7, 163, 163, 1),
                                                fontSize: 18)),
                                        Text(report[index].rating,
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.crop_square),
                                        Text("Number Of Visit : ",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    7, 163, 163, 1),
                                                fontSize: 18)),
                                        Text(
                                            report[index]
                                                .numberOfVisit
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    )
                                  ],
                                ),
                                // VerticalDivider(
                                //   thickness: 50,
                                //   width: 50,
                                //   color: Color.fromRGBO(7, 163, 163, 1),
                                // ),
                                // report[index].visitType == "PhysicianVisit"
                                //     ? Icon(
                                //         FontAwesomeIcons.stethoscope,
                                //         color: Color.fromRGBO(7, 163, 163, 1),
                                //       )
                                //     : report[index].visitType == "PharmacyVisit"
                                //         ? Icon(
                                //             FontAwesomeIcons.handHoldingMedical,
                                //             color:
                                //                 Color.fromRGBO(7, 163, 163, 1),
                                //           )
                                //         : Icon(
                                //             FontAwesomeIcons.hospital,
                                //             color:
                                //                 Color.fromRGBO(7, 163, 163, 1),
                                //           )
                              ],
                            ),
                            Divider(
                              height: 50,
                              color: Color.fromRGBO(7, 163, 163, 1),
                            )
                          ],
                        )));
          },
        ),
      ),
    );
  }
}