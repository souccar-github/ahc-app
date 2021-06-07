import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:template/API/Statics.dart';
import 'package:template/Models/General/AuthModel.dart';

class General {
  
  General._();
  static final General apiClient = General._();
  Future<String> login(AuthModel authModel) async {
    String error;

    try {
      final response = await Statics.httpClient.post(Statics.BaseUrl +"/api/auth/login",
          body: jsonEncode(authModel.toJson()),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '${authModel.username}:${authModel.password}',
          });
      if (response.statusCode == 200) {
        return "success";
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