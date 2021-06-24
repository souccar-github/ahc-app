import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Screens/General/SplashScreen.dart';
import 'package:template/Screens/Project/CopyPlannedToActual.dart';
import 'package:template/Screens/Project/CopyPlannedToPlanned.dart';
import 'package:template/SharedPref/SharedPref.dart';

import '../../main.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawer createState() => _AppDrawer();
}

class _AppDrawer extends State<AppDrawer> {
  var username = "";

  @override
  void initState() {
    super.initState();
  }

  Widget _createHeader() {
    Future.delayed(Duration.zero, () async {
      var _username = await SharedPref.pref.getUserName();

      setState(() {
        username = _username;
      });
    });
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('lib/assets/identety.png'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 12.0,
              child: Text(
                Localization.of(context).getTranslatedValue("Welcome") +
                    " .. " +
                    username,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(7, 163, 163, 1)),
              )),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Color.fromRGBO(7, 163, 163, 1),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          Divider(
            color: Color.fromRGBO(7, 163, 163, 1),
            thickness: 5,
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.home,
            text: Localization.of(context).getTranslatedValue("Home"),
            onTap: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
            },
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.copy,
            text: Localization.of(context)
                .getTranslatedValue("Copyfromplannedtoactual"),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CopyPlannedToActual()));
            },
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.copy,
            text: Localization.of(context)
                .getTranslatedValue('CopyfromplannedtoPlanned'),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CopyPlannedToPlanned()));
            },
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.signOutAlt,
            text: Localization.of(context).getTranslatedValue("SwitchLanguage"),
            onTap: () async {
              var locale = null;
              locale = await SharedPref.pref.getLocale();
              if (locale == "en") {
                MyApp.setLocale(
                    context, Locale.fromSubtags(languageCode: 'ar'));
                await SharedPref.pref.setLocale("ar");
              } else {
                MyApp.setLocale(
                    context, Locale.fromSubtags(languageCode: 'en'));
                await SharedPref.pref.setLocale("en");
              }
              
            },
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.signOutAlt,
            text: Localization.of(context).getTranslatedValue("Signout"),
            onTap: () async {
              await SharedPref.pref.setUserName(null);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}
