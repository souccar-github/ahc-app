import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/Screens/General/SplashScreen.dart';
import 'package:template/SharedPref/SharedPref.dart';

class AppDrawer extends StatelessWidget {
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
            text: 'Home',
            onTap: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
            },
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.signOutAlt,
            text: 'Sign out',
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

  Widget _createHeader() {
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
          Positioned(bottom: 12.0, left: 16.0, child: Container()),
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
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
