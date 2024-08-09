import 'dart:convert';
import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/site_model.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  String apiURL = "";
  String userName = "";
  String userPassword = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final db = DatabaseHelper();

  Future<void> fetchUserData(BuildContext context) async {
    List<SiteModel> siteModels = List.empty();
    _prefs.then((SharedPreferences prefs) async {
      apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
      userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
      userPassword = prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
      try {
        await http.get(
          Uri.parse("$apiURL/api/tracker/api_login"),
          headers: <String, String>{
            "accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
          },
        ).then((value) {
          if (value.statusCode == 200) {
            final responseData = jsonDecode(value.body);
            prefs.setString(
                SharedPreferencesKeys.userId, responseData["userId"]);
            prefs.setString(SharedPreferencesKeys.userFirstName,
                responseData["userFirstName"]);
            prefs.setString(SharedPreferencesKeys.userLastName,
                responseData["userLastName"]);
            prefs.setString(
                SharedPreferencesKeys.userLogin, responseData["userLogin"]);
            prefs.setString(
                SharedPreferencesKeys.userType, responseData["userType"]);
            return siteModels;
          } else {
            Utils.showErrorSnackBar(
                context, "Failed to get data from the server");
          }
        });
      } catch (e) {
        return null;
      }
    }).catchError((error, stackTrace) {
      return null;
    });
  }
}
