import 'dart:convert';
import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LabService {
  String apiURL = "";
  String userName = "";
  String userPassword = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final db = DatabaseHelper();

  Future<void> fetchLabsData(BuildContext context) async {
    _prefs.then((SharedPreferences prefs) async {
      apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
      userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
      userPassword = prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
      try {
        await http.get(
          Uri.parse("$apiURL/lab/names_by_users"),
          headers: <String, String>{
            "accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
          },
        ).then((value) {
          if (value.statusCode == 200) {
            final List<dynamic> responseData = jsonDecode(value.body);
            List<LabModel> labModels =
                responseData.map((e) => LabModel.fromJson(e)).toList();
            db.deleteAllLabs().then((value) => {
                  labModels.forEach((element) async {
                    await db.createLab(element);
                  }),
                });
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

  Future<LabModel?> fetchLabById(int id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
      final String userName =
          prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
      final String userPassword =
          prefs.getString(SharedPreferencesKeys.userPassword) ?? "";

      final http.Response response = await http.get(
        Uri.parse("$apiURL/lab/name_by_id/$id"),
        headers: <String, String>{
          "accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
        },
      );
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        return LabModel.fromJson(responseData);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }
}
