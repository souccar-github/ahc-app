import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/report_bloc.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Models/Project/ActualVisitModel.dart';
import 'package:template/Widgets/Project/Drawer.dart';

class PlannedReport extends StatefulWidget {
  final int id;
  PlannedReport(this.id);
  @override
  _PlannedReport createState() => _PlannedReport();
}

class _PlannedReport extends State<PlannedReport> {
  var reportBloc;
  int _selectedIndex;
  List<ActualVisitModel> report;
  @override
  void initState() {
    reportBloc = new ReportBloc();
    _selectedIndex = 0;
    reportBloc.add(GetPlannedReport(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          Localization.of(context).getTranslatedValue("PlannedReport"),
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
              current is PlannedReportSuccessfully || current is ReportLoading,
          builder: (context, state) {
            if (state is PlannedReportSuccessfully) {
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.crop_square),
                                        Text(Localization.of(context).getTranslatedValue("Type")+" : ",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    7, 163, 163, 1),
                                                fontSize: 18)),
                                        Text(
                                            report[index].visitType ==
                                                    "PhysicianVisit"
                                                ? Localization.of(context).getTranslatedValue("Physician")
                                                : report[index].visitType ==
                                                        "HospitalVisit"
                                                    ? Localization.of(context).getTranslatedValue("Hospital")
                                                    : Localization.of(context).getTranslatedValue("Pharmacy"),
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.crop_square),
                                        Text(Localization.of(context).getTranslatedValue("Name")+" : ",
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
                                      Text(Localization.of(context).getTranslatedValue("Address")+" : ",
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
                                        Text(Localization.of(context).getTranslatedValue("Rating")+" : ",
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
                                        Text(Localization.of(context).getTranslatedValue("NumberOfVisit")+" : ",
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
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.crop_square),
                                        Text(Localization.of(context).getTranslatedValue("DatesOfVisit")+" : ",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    7, 163, 163, 1),
                                                fontSize: 18)),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              height: report[index]
                                                              .dates
                                                              .length
                                                              .toDouble() *
                                                          15 <
                                                      60
                                                  ? report[index]
                                                          .dates
                                                          .length
                                                          .toDouble() *
                                                      15
                                                  : 60,
                                              width: 200,
                                              child: ListView.builder(
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                itemCount:
                                                    report[index].dates.length,
                                                itemBuilder: (context, i) =>
                                                    Column(
                                                  children: [
                                                    Text(
                                                      report[index]
                                                              .dates[i]
                                                              .day
                                                              .toString() +
                                                          " / " +
                                                          report[index]
                                                              .dates[i]
                                                              .month
                                                              .toString() +
                                                          " / " +
                                                          report[index]
                                                              .dates[i]
                                                              .year
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
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
