import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/Bloc/General/bloc/auth_bloc.dart';
import 'package:template/Screens/Project/Months.dart';
import 'package:template/Widgets/General/LoginUI.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AuthBloc authBloc;
  @override
  void initState() {
    authBloc = new AuthBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
          cubit: authBloc,
          listenWhen: (prev, cur) =>
              cur is LoginSuccessfully || cur is LoginError,
          listener: (context, state) {
            if (state is LoginSuccessfully) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Months()));
            }
            if (state is LoginError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: LoginUI(authBloc,MediaQuery.of(context).size)),
    );
  }
}
