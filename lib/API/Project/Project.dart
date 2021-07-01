import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:template/API/Statics.dart';
import 'package:template/Bloc/Project/bloc/physicianproduct_bloc.dart';
import 'package:template/Bloc/Project/bloc/report_bloc.dart';
import 'package:template/Localization/Localization.dart';
import 'package:template/Models/Project/ActualModel.dart';
import 'package:template/Models/Project/ActualVisitModel.dart';
import 'package:template/Models/Project/ClinicModel.dart';
import 'package:template/Models/Project/DateModel.dart';
import 'package:template/Models/Project/HosProductModel.dart';
import 'package:template/Models/Project/ListItemModel.dart';
import 'package:template/Models/Project/MonthModel.dart';
import 'package:http/http.dart' as http;
import 'package:template/Models/Project/PhaProductModel.dart';
import 'package:template/Models/Project/PhyProductModel.dart';
import 'package:template/Models/Project/PlanningTaskModel.dart';
import 'package:template/SharedPref/SharedPref.dart';

class Project {
  Project._();
  static final Project apiClient = Project._();
  Future<List<MonthModel>> getMonths() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/month/get", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<MonthModel> months = new List<MonthModel>();
        List monthListModel = json.decode(response.body);
        for (var i = 0; i < monthListModel.length; i++) {
          MonthModel h = MonthModel.fromJson(monthListModel[i]);
          months.add(h);
        }
        if (months != null) {
          return months;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deleteMonth(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .delete(Statics.BaseUrl + "/api/month/delete/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        return "success";
      }else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
      }else {
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

  Future addMonth(int _month, int year) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      MonthModel month = new MonthModel("", year, _month, 0);
      final response =
          await Statics.httpClient.post(Statics.BaseUrl + "/api/month/create",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(month.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future updateMonth(int id, int _month, int year) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      MonthModel month = new MonthModel("", year, _month, id);
      final response =
          await Statics.httpClient.post(Statics.BaseUrl + "/api/month/update",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(month.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future addPlannedTask(PlanningTaskModel task) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response =
          await Statics.httpClient.post(Statics.BaseUrl + "/api/planned/create",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(task.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<bool> checkHolidayActual(String monthId, String day) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.post(
          Statics.BaseUrl + "/api/month/checkHolidayActual/$monthId/$day",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        var value = response.body;
        return value.toLowerCase() == "true";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<DateModel>> getPlannedTasks(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/planned/get/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<DateModel> events = new List<DateModel>();
        List eventListModel = json.decode(response.body);
        for (var i = 0; i < eventListModel.length; i++) {
          DateModel h = DateModel.fromJson(eventListModel[i]);
          events.add(h);
        }
        if (events != null) {
          return events;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getDayPlannedTasks(int id, int day) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/planned/getDayTasks/$id/$day", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> events = new List<ListItemModel>();
        List eventListModel = json.decode(response.body);
        for (var i = 0; i < eventListModel.length; i++) {
          ListItemModel h = ListItemModel.fromJson(eventListModel[i]);
          events.add(h);
        }
        if (events != null) {
          return events;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getDayActualTasks(int id, int day) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/actual/getDayTasks/$id/$day", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> events = new List<ListItemModel>();
        List eventListModel = json.decode(response.body);
        for (var i = 0; i < eventListModel.length; i++) {
          ListItemModel h = ListItemModel.fromJson(eventListModel[i]);
          events.add(h);
        }
        if (events != null) {
          return events;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<DateModel>> getActualTasks(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/actual/get/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<DateModel> events = new List<DateModel>();
        List eventListModel = json.decode(response.body);
        for (var i = 0; i < eventListModel.length; i++) {
          DateModel h = DateModel.fromJson(eventListModel[i]);
          events.add(h);
        }
        if (events != null) {
          return events;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getHospitals() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/hospital/get", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getHospitalsShort() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/hospital/getShort", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPhysicians() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/physician/get", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPhysiciansShort() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/physician/getShort", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPharmacies() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/pharmacy/get", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPharmaciesShort() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/pharmacy/getShort", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getEmployees() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/employee/get", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items.length == 0) {
          return Future.error(
              "لا يمكن إدخال مهمة تقييم لعدم وجود موظفين تحت إشرافك");
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getOtherTask() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/otherTask/get", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<PlanningTaskModel> getPlannedTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/planned/getById/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        PlanningTaskModel task =
            PlanningTaskModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deletePlannedTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .delete(Statics.BaseUrl + "/api/planned/delete/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future updatePlannedTask(PlanningTaskModel task) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response =
          await Statics.httpClient.post(Statics.BaseUrl + "/api/planned/edit",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(task.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPeriods() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/reference/GetPeriods", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getProvidedMaterial() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.get(
          Statics.BaseUrl + "/api/reference/GetProvidedMaterial",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        List<ListItemModel> items = new List<ListItemModel>();
        List _items = json.decode(response.body);
        for (var i = 0; i < _items.length; i++) {
          ListItemModel h = ListItemModel.fromJson(_items[i]);
          items.add(h);
        }
        if (items != null) {
          return items;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future addActualTask(ActualModel task) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response =
          await Statics.httpClient.post(Statics.BaseUrl + "/api/actual/create",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(task.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future updateActualTask(ActualModel task) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response =
          await Statics.httpClient.post(Statics.BaseUrl + "/api/actual/update",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(task.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPhyPro(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.get(
          Statics.BaseUrl + "/api/physicianProduct/get/" + id.toString(),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPhaPro(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/pharmacyProduct/get/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getHosPro(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/clinicProduct/get/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getClinics(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/hospitalClinicVisit/get/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deletePhaActualTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .delete(Statics.BaseUrl + "/api/pharmacyVisit/delete/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deletePhyActualTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .delete(Statics.BaseUrl + "/api/physicianVisit/delete/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deleteHosActualTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .delete(Statics.BaseUrl + "/api/hospitalVisit/delete/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<ActualModel> getPhyActualTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/physicianVisit/getById/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        ActualModel task = ActualModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<ActualModel> getOtherActualTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/otherTask/getById/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        ActualModel task = ActualModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<PhaProductModel> getPhaProduct(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/pharmacyProduct/getById/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        PhaProductModel task =
            PhaProductModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<PhyProductModel> getPhyProduct(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/physicianProduct/getById/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        PhyProductModel task =
            PhyProductModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<HosProductModel> getHosProduct(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/clinicProduct/getById/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        HosProductModel task =
            HosProductModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<ClinicModel> getClinic(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.get(
          Statics.BaseUrl + "/api/hospitalClinicVisit/getById/$id",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        ClinicModel task = ClinicModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<ActualModel> getPhaActualTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/pharmacyVisit/getById/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        ActualModel task = ActualModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<ActualModel> getHosActualTask(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/hospitalVisit/getById/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        ActualModel task = ActualModel.fromJson(json.decode(response.body));
        return task;
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getProducts() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/reference/getProducts", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPlannedToActualServiceTasks(
      String date) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.get(
          Statics.BaseUrl + "/api/Service/getPlannedTasks/$date",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getPlannedToPlannedServiceTasks(
      String fromDate, String toDate) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.get(
          Statics.BaseUrl + "/api/Service/getTasks/$fromDate/$toDate",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getAdoptions() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/reference/getAdoptions", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getComplaints() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/reference/getComplaints", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getDropDownClinics() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/reference/getClinics", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ListItemModel>> getVisitTypes() async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/reference/getVisitTypes", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ListItemModel> _list = new List<ListItemModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ListItemModel h = ListItemModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ActualVisitModel>> getPharmacyReport(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.get(
          Statics.BaseUrl + "/api/pharmacyVisit/getReportData/$id",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        List<ActualVisitModel> _list = new List<ActualVisitModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ActualVisitModel h = ActualVisitModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ActualVisitModel>> getHospitalReport(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.get(
          Statics.BaseUrl + "/api/hospitalVisit/getReportData/$id",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        List<ActualVisitModel> _list = new List<ActualVisitModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ActualVisitModel h = ActualVisitModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ActualVisitModel>> getPhysicianReport(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.get(
          Statics.BaseUrl + "/api/physicianVisit/getReportData/$id",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        List<ActualVisitModel> _list = new List<ActualVisitModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ActualVisitModel h = ActualVisitModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ActualVisitModel>> getOtherReport(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/otherTask/getReportData/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ActualVisitModel> _list = new List<ActualVisitModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ActualVisitModel h = ActualVisitModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future<List<ActualVisitModel>> getPlannedReport(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .get(Statics.BaseUrl + "/api/planned/getReportData/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        List<ActualVisitModel> _list = new List<ActualVisitModel>();
        List list = json.decode(response.body);
        for (var i = 0; i < list.length; i++) {
          ActualVisitModel h = ActualVisitModel.fromJson(list[i]);
          _list.add(h);
        }
        if (_list != null) {
          return _list;
        }
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future addPhaProduct(PhaProductModel product) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/pharmacyProduct/create",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(product.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future addPhyProduct(PhyProductModel product) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/physicianProduct/create",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(product.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future addClinic(ClinicModel clinic) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/hospitalClinicVisit/create",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(clinic.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future copyPlannedToActualService(List<String> tasks) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/Service/copyPlannedToActual",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(tasks));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future copyPlannedToPlannedService(List<String> tasks, String toDate) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/Service/copyPlannedToPlanned/$toDate",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(tasks));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future addHosProduct(HosProductModel product) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/clinicProduct/create",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(product.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deletePhyProduct(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.delete(
          Statics.BaseUrl + "/api/physicianProduct/delete/$id",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deletePhaProduct(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.delete(
          Statics.BaseUrl + "/api/pharmacyProduct/delete/$id",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deleteHosProduct(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .delete(Statics.BaseUrl + "/api/clinicProduct/delete/$id", headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': '$username:$password',
        'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
      });
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future deleteClinic(int id) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient.delete(
          Statics.BaseUrl + "/api/hospitalClinicVisit/delete/$id",
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': '$username:$password',
            'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
          });
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future updatePhyProduct(PhyProductModel task) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/physicianProduct/update",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(task.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future updateHosProduct(HosProductModel task) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/clinicProduct/update",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(task.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future updateClinic(ClinicModel task) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/hospitalClinicVisit/update",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(task.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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

  Future updatePhaProduct(PhaProductModel task) async {
    String error;
    try {
      var username = await SharedPref.pref.getUserName();
      var password = await SharedPref.pref.getPassword();
      final response = await Statics.httpClient
          .post(Statics.BaseUrl + "/api/pharmacyProduct/update",
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': '$username:$password',
                'locale': await SharedPref.pref.getLocale() == "en"?"49":"14"
              },
              body: jsonEncode(task.toJson()));
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized");
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
