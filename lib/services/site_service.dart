import 'dart:convert';
import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/site_model.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SiteService {
  String apiURL = "";
  String userName = "";
  String userPassword = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final db = DatabaseHelper();

  Future<void> fetchSitesData(BuildContext context) async {
    _prefs.then((SharedPreferences prefs) async {
      apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
      userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
      userPassword = prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
      try {
        await http.get(
          Uri.parse("$apiURL/site/names_circuits"),
          headers: <String, String>{
            "accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
          },
        ).then((value) {
          if (value.statusCode == 200) {
            final List<dynamic> responseData = jsonDecode(value.body);
            List<SiteModel> siteModels =
                responseData.map((e) => SiteModel.fromJson(e)).toList();
            siteModels.forEach((element) {
              db.createSite(element);
            });
          } else {
            Utils.showErrorSnackBar(context, "Failed to get data from the server");
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
