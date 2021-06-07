import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

class MultiSelect extends StatefulWidget {
  final String title;
  final List<String> selected;
  final List<S2Choice<String>> items;
  final IconData icon;
  final Function(List<String>) callback;

  MultiSelect(
      {this.title,
      this.selected,
      this.items,
      this.icon,
      this.callback});
  @override
  _MultiSelect createState() => _MultiSelect();
}

class _MultiSelect extends State<MultiSelect> {
  List<String> selected;

  @override
  void initState() {
    selected = new List<String>();
    for (var i = 0; i < widget.items.length; i++) {
      selected.add(widget.items[i].value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartSelect<String>.multiple(
      title: widget.title,
      value: selected,
      onChange: (state) {
        setState(() {
          selected = state.value;
        });
        this.widget.callback(selected);
      },
      modalActionsBuilder: (context, state) {
            return <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 13),
                child: state.choiceSelector,
              )
            ];
          },
      choiceItems: widget.items,
      modalType: S2ModalType.bottomSheet,
      placeholder: (widget.items?.length == null
              ? "0"
              : widget.items.length.toString()) +
          " items.",
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          leading: Icon(
            widget.icon,
            color: Color.fromRGBO(7, 163, 163, 1),
          ),
        );
      },
    );
  }
}
