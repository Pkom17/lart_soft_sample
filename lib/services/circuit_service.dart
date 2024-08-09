import 'dart:convert';
import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/circuit_model.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CircuitService {
  String apiURL = "";
  String userName = "";
  String userPassword = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final db = DatabaseHelper();

  Future<void> fetchCircuitsData(BuildContext context) async {
    _prefs.then((SharedPreferences prefs) async {
      apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
      userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
      userPassword = prefs.getString(SharedPreferencesKeys.userPassword) ?? "";

      try {
        await http.get(
          Uri.parse("$apiURL/circuit/numbers_by_users"),
          headers: <String, String>{
            "accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
          },
        ).then((value) {
          if (value.statusCode == 200) {
            final List<dynamic> responseData = jsonDecode(value.body);
            List<CircuitModel> circuitModels =
                responseData.map((e) => CircuitModel.fromJson(e)).toList();
            db.deleteAllCircuits().then((value) => {
                  circuitModels.forEach((element) async {
                    await db.createCircuit(element);
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
}
