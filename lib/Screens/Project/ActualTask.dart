import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/Project/bloc/actual_bloc.dart';
import 'package:template/Localization/Localization.dart';

class ActualTask extends StatefulWidget {
  @override
  _ActualTask createState() => _ActualTask();
}

class _ActualTask extends State<ActualTask> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Localization.of(context).getTranslatedValue("ActualTask"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocListener<ActualBloc, ActualState>(
        listenWhen: (previous, current) => current is ActualTaskError,
        listener: (context, state) {
          // TODO: implement listener
        },
        child: BlocBuilder<ActualBloc, ActualState>(
          buildWhen: (previous, current) =>
              current is InitAddActualSuccessfully ||
              current is InitUpdateActualSuccessfully,
          builder: (context, state) {
            if (state is InitAddActualSuccessfully) {
              return BlocBuilder<ActualBloc, ActualState>(
                builder: (context, state) {
                  return Container();
                },
              );
            } else if (state is InitUpdateActualSuccessfully) {
              return BlocBuilder<ActualBloc, ActualState>(
                builder: (context, state) {
                  return Container();
                },
              );
            }
          },
        ),
      ),
    );
  }
}
