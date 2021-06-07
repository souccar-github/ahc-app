import 'dart:core';

import 'package:http/http.dart' as http;

class Statics {
  static final http.Client httpClient = http.Client();
  static const BaseUrl = "http://fb3f9f56dbe4.ngrok.io";
}
