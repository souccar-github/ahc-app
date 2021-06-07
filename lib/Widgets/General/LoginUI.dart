import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/General/bloc/auth_bloc.dart';
import 'package:template/Widgets/General/Button.dart';
import 'package:template/Widgets/General/TextFormField.dart';

import 'Animation/delayed_animation.dart';

class LoginUI extends StatefulWidget {
  final AuthBloc authBloc;
  final Size sizeAware;
  LoginUI(this.authBloc, this.sizeAware);
  @override
  _LoginState createState() => _LoginState(authBloc, sizeAware);
}

class _LoginState extends State<LoginUI> {
  final AuthBloc authBloc;
  final _formKey = new GlobalKey<FormState>();
  final Size sizeAware;
  _LoginState(this.authBloc, this.sizeAware);
  String name = "";
  String password = "";
  int delayedAmount = 500;
  void _onChangedUsername(String text) {
    setState(() {
      name = text;
    });
  }

  void _onChangedPassword(String text) {
    setState(() {
      password = text;
    });
  }

  void _onPressed() {
    if (_formKey.currentState.validate()) {
      authBloc.add(Login(name, password));
    }
  }

  String validator(String text) {
    if (text == "" || text == null) {
      return "Required";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: sizeAware.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/identety.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DelayedAnimation(
                      delay: delayedAmount + 200,
                      child: Image.asset(
                        'lib/assets/logo.png',
                        height: 400,
                        width: 200,
                      )),
                  DelayedAnimation(
                    child: textFormField(_onChangedUsername, "Username", true,
                        TextInputType.text, false, 1, null),
                    delay: delayedAmount + 400,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  DelayedAnimation(
                    child: textFormField(_onChangedPassword, "Password", true,
                        TextInputType.text, true, 1, null),
                    delay: delayedAmount + 600,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                      cubit: authBloc,
                      buildWhen: (prev, cur) =>
                          cur is Loading || cur is LoginError,
                      builder: (context, state) {
                        if (state is Loading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return DelayedAnimation(
                            child: button("Login", _onPressed),
                            delay: delayedAmount + 800,
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
