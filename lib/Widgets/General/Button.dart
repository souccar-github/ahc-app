import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget button(String _title, Function() _onPressed) {
  return ButtonTheme(
      minWidth: 175.0,
      height: 50.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0),
            side: BorderSide(color: Color.fromRGBO(7, 163, 163, 1))),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: Color.fromRGBO(7, 163, 163, 1),
        child: Text(
          _title,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        onPressed: _onPressed,
      ));
}
