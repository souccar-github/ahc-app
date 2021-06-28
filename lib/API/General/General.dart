import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:template/API/Statics.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Models/General/AuthModel.dart';
import 'package:template/SharedPref/SharedPref.dart';

class General {
  BuildContext context;
  General._();
  static final General apiClient = General._();
  Future<String> login(AuthModel authModel) async {
    String error;

    try {
      var locale = await SharedPref.pref.getLocale();
      final response = await Statics.httpClient.post(Statics.BaseUrl +"/api/auth/login",
          body: jsonEncode(authModel.toJson()),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '${authModel.username}:${authModel.password}',
            'local':locale
          });
      if (response.statusCode == 200) {
        return "success";
      }else if (response.statusCode == 401) {
        return Future.error("Error in username or password");
      } else {
        error = (jsonDecode(response.body))["Message"] as String;
        return Future.error(error ?? "Unknown Error"); 
      }
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}