import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/SharedPref/SharedPref.dart';

import '../../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage();

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var locale = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () async {
      var _locale = await SharedPref.pref.getLocale();
      setState(() {
        locale = _locale;
      });
    });
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            Localization.of(context).getTranslatedValue("Setting"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(7),
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return InkWell(
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Stack(children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.language,
                                      color: Color.fromRGBO(7, 163, 163, 1),
                                    ),
                                  ),
                                  Text(
                                      locale == "en"
                                          ? Localization.of(context)
                                              .getTranslatedValue(
                                                  "ArabicLanguage")
                                          : Localization.of(context)
                                              .getTranslatedValue(
                                                  "EnglishLanguage"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
                onTap: () {
                  Future.delayed(Duration(milliseconds: 0), () async {
                    if (locale == "en") {
                      MyApp.setLocale(
                          context, Locale.fromSubtags(languageCode: 'ar'));
                      await SharedPref.pref.setLocale("ar");
                    } else {
                      MyApp.setLocale(
                          context, Locale.fromSubtags(languageCode: 'en'));
                      await SharedPref.pref.setLocale("en");
                    }
                  });
                },
              );
            },
          ),
        ));
  }
}
