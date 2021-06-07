import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/Bloc/Project/bloc/clinic_bloc.dart';
import 'package:template/Bloc/Project/bloc/hosproduct_bloc.dart';
import 'package:template/Bloc/Project/bloc/phaproduct_bloc.dart';
import 'package:template/Bloc/Project/bloc/physicianproduct_bloc.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Screens/Project/Clinic.dart';
import 'package:template/Widgets/General/Drawer.dart';
import 'package:template/Widgets/General/List.dart';

import 'Products.dart';

class Clinics extends StatefulWidget {
  final int id;
  Clinics(this.id);
  @override
  _Clinics createState() => _Clinics();
}

class _Clinics extends State<Clinics> {
  var clinicBloc;

  @override
  void initState() {
    clinicBloc = new ClinicBloc();
    clinicBloc.add(InitClinics(widget.id));
    super.initState();
  }

  deleteClinic(int id, String type) {
    clinicBloc.add(DeleteClinic(id));
  }

  updateClinic(ListItemModel model) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Clinic(model.id, clinicBloc, true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Clinic(widget.id, clinicBloc, false)));
        },
      ),
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          'Clinics',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<ClinicBloc, ClinicState>(
        cubit: clinicBloc,
        listenWhen: (previous, current) => current is ClinicError,
        listener: (context, state) {
          if (state is ClinicError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<ClinicBloc, ClinicState>(
          cubit: clinicBloc,
          buildWhen: (previous, current) =>
              current is InitClinicsSuccessfully ||
              current is DeleteClinicSuccessfully ||
              current is ClinicLoading,
          builder: (context, state) {
            if (state is InitClinicsSuccessfully) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: viewList(
                      state.clinics,
                      deleteClinic,
                      updateClinic,
                      (task) => [
                            IconSlideAction(
                              caption: '',
                              color: Color.fromRGBO(7, 163, 163, 1),
                              icon: FontAwesomeIcons.boxes,
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Products("HospitalVisit", task.id))),
                            )
                          ]));
            } else if (state is DeleteClinicSuccessfully) {
              clinicBloc.add(InitClinics(widget.id));
            } else if (state is ClinicLoading) {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
