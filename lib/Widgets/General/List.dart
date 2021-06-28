import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Models/Project/ListItemModel.dart';

Widget viewList(
    List<ListItemModel> list,
    Function(int, String) delete,
    Function(ListItemModel) update,
    List<Widget> Function(ListItemModel) actions) {
  List<Widget> buildList(index) {
    List<Widget> _secList = actions(list[index]);
    List<Widget> _list = <Widget>[
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => delete(list[index].id, list[index].type),
      ),
      IconSlideAction(
        caption: 'Update',
        color: Colors.orange,
        icon: Icons.update,
        onTap: () => update(list[index]),
      )
    ];
    _list.addAll(_secList);
    return _list;
  }

  return ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: list.length,
    itemBuilder: (context, index) => Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: Container(
        color: Colors.white,
        child: ListTile(
            leading: CircleAvatar(
                child: Icon(
              Icons.crop_square,
            )),
            subtitle: Text(
              list[index].body,
              style: TextStyle(color: Color.fromRGBO(7, 163, 163, 1)),
            ),
            title: Text(
              list[index].title,
              style: TextStyle(
                  color: Color.fromRGBO(7, 163, 163, 1), fontSize: 20),
            )),
      ),
      actions: actions(list[index]),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: Localization.of(context).getTranslatedValue("Delete"),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => delete(list[index].id, list[index].type),
        ),
        IconSlideAction(
          caption: Localization.of(context).getTranslatedValue("Update"),
          color: Colors.orange,
          icon: Icons.update,
          onTap: () => update(list[index]),
        )
      ],
    ),
  );
}
