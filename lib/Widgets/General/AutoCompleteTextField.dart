import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget autoCompleteTextField(TextEditingController _controller,
    List<String> _suggestions, String _hint, Function(String) _itemSupmitted) {
  var _key = new GlobalKey<AutoCompleteTextFieldState<String>>();
  return AutoCompleteTextField<String>(
    clearOnSubmit: false,
    controller: _controller,
    suggestions: _suggestions,
    style: TextStyle(color: Colors.black, fontSize: 16.0),
    decoration: new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      filled: true,
      fillColor: Colors.white,
      hintText: _hint,
      labelStyle: TextStyle(color: Color.fromRGBO(7, 163, 163, 1)),
      enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20.0),
        borderSide: new BorderSide(
            style: BorderStyle.solid, color: Color.fromRGBO(7, 163, 163, 0.5)),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20.0),
        borderSide: new BorderSide(
            style: BorderStyle.solid, color: Color.fromRGBO(7, 163, 163, 0.5)),
      ),
      focusedErrorBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20.0),
        borderSide:
            new BorderSide(style: BorderStyle.solid, color: Colors.red[200]),
      ),
      errorBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20.0),
        borderSide:
            new BorderSide(style: BorderStyle.solid, color: Colors.red[200]),
      ),
      errorStyle: TextStyle(
        color: Colors.red[200],
      ),
    ),
    itemFilter: (item, query) {
      return item.toLowerCase().startsWith(query.toLowerCase());
    },
    itemSorter: (a, b) {
      return a.compareTo(b);
    },
    itemSubmitted:(value)=> _itemSupmitted(value),
    itemBuilder: (context, item) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      );
    },
  );
}
