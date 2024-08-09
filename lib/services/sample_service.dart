import 'dart:convert';
import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SampleService {
  String apiURL = "";
  String userName = "";
  String userPassword = "";

  final db = DatabaseHelper();
  var actionURLMap = {
    "COLLECT_SAMPLE_ON_SITE": "/api/tracker/collect_sample_on_site",
    "DELIVER_SAMPLE_AT_HUB": "/api/tracker/deliver_sample_at_hub",
    "ACCEPT_SAMPLE_AT_HUB": "/api/tracker/accept_sample_at_hub",
    "REJECT_SAMPLE": "/api/tracker/reject_sample",
    "COLLECT_SAMPLE_AT_HUB": "/api/tracker/collect_sample_at_hub",
    "DELIVER_SAMPLE_AT_LAB": "/api/tracker/deliver_sample_at_lab",
    "ACCEPT_SAMPLE_AT_LAB": "/api/tracker/accept_sample_at_lab",
    "COLLECT_RESULT": "/api/tracker/collect_result",
    "DELIVER_RESULT": "/api/tracker/deliver_result",
    "ANALYSIS_DONE": "/api/tracker/analysis_done",
    "ANALYSIS_FAILED": "/api/tracker/analysis_failed",
    "TRANSFER_SAMPLE": "/api/tracker/transfer_sample",
  };

  Future<bool> postSampleData(SampleModel sampleModel, String action) async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
    userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
    userPassword = prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
    try {
      final String requestBody = json.encode(sampleModel.toJson());
      var uri = actionURLMap[action];
      await http
          .post(
        Uri.parse("$apiURL$uri"),
        headers: <String, String>{
          "accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
        },
        encoding: Encoding.getByName('utf-8'),
        body: requestBody,
      )
          .then((value) {
        if (value.statusCode == 201) {
          result = true;
        } else {
          result = false;
          throw Exception(
              'Failed to post data:  HTTP status code ${value.statusCode}');
        }
      });
    } catch (e) {
      return false;
    }
    return result;
  }

  Future<List<SampleModel>> fetchSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    List<SampleModel> samples = List.empty();
    final apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
    final userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
    final userPassword =
        prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
    final apiEndpoint = '$apiURL/api/tracker/sample_in_transit';
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: <String, String>{
        "accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      samples = responseData.map((e) {
        return SampleModel.fromJson(e);
      }).toList();
      return samples;
    } else {
      throw Exception(
          'Erreur lors du chargement des données:  HTTP status code ${response.statusCode}');
    }
  }

  Future<List<SampleModel>> fetchSampleForLab(int labId) async {
    final prefs = await SharedPreferences.getInstance();
    List<SampleModel> samples = List.empty();
    final apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
    final userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
    final userPassword =
        prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
    final apiEndpoint = '$apiURL/api/tracker/sample_in_transit/lab/$labId';
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: <String, String>{
        "accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      samples = responseData.map((e) {
        return SampleModel.fromJson(e);
      }).toList();
      return samples;
    } else {
      throw Exception(
          'Erreur lors du chargement des données:  HTTP status code ${response.statusCode}');
    }
  }

  Future<List<SampleModel>> fetchDeliveredSample(int labId) async {
    final prefs = await SharedPreferences.getInstance();
    List<SampleModel> samples = List.empty();
    final apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
    final userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
    final userPassword =
        prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
    final apiEndpoint = '$apiURL/api/tracker/sample_at_lab/$labId';
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: <String, String>{
        "accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      samples = responseData.map((e) {
        return SampleModel.fromJson(e);
      }).toList();
      return samples;
    } else {
      throw Exception(
          'Erreur lors du chargement des données:  HTTP status code ${response.statusCode}');
    }
  }

  Future<List<SampleModel>> fetchSamplesAcceptedInLab(int labId) async {
    final prefs = await SharedPreferences.getInstance();
    List<SampleModel> samples = List.empty();
    final apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
    final userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
    final userPassword =
        prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
    final apiEndpoint = '$apiURL/api/tracker/sample_at_lab_accepted/$labId';
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: <String, String>{
        "accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      samples = responseData.map((e) {
        return SampleModel.fromJson(e);
      }).toList();
      return samples;
    } else {
      throw Exception(
          'Erreur lors du chargement des données:  HTTP status code ${response.statusCode}');
    }
  }

  Future<List<SampleModel>> fetchSampleResultForLab(int labId) async {   
    final prefs = await SharedPreferences.getInstance();
    List<SampleModel> samples = List.empty();
    final apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
    final userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
    final userPassword =
        prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
    final apiEndpoint = '$apiURL/api/tracker/analysis_done_at_lab/$labId';
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: <String, String>{
        "accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      samples = responseData.map((e) {
        return SampleModel.fromJson(e);
      }).toList();
      return samples;
    } else {
      throw Exception(
          'Erreur lors du chargement des données:  HTTP status code ${response.statusCode}');
    }
  }

  Future<List<SampleModel>> fetchCollectedResultForSite(int siteId) async {
    final prefs = await SharedPreferences.getInstance();
    List<SampleModel> samples = List.empty();
    final apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
    final userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
    final userPassword =
        prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
    final apiEndpoint = '$apiURL/api/tracker/result_for_site/$siteId';
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: <String, String>{
        "accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      samples = responseData.map((e) {
        return SampleModel.fromJson(e);
      }).toList();
      return samples;
    } else {
      throw Exception(
          'Erreur lors du chargement des données:  HTTP status code ${response.statusCode}');
    }
  }

  Future<bool> deleteSample(int sampleId) async {
    final prefs = await SharedPreferences.getInstance();
    final apiURL = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
    final userName = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
    final userPassword =
        prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
    final apiEndpoint = '$apiURL/api/tracker/delete_sample/$sampleId';
    final response = await http.post(
      Uri.parse(apiEndpoint),
      headers: <String, String>{
        "accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$userPassword'))}',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postStoredSampleData() async {
    final db = DatabaseHelper();
    List<SampleModel> samples = await db.retrieveAllSamples();
    int count = samples.length;
    int ranSucess = 0;
    samples.forEach((element) async {
      await postSampleData(element, SampleActionKeys.COLLECT_SAMPLE_ON_SITE)
          .then((value) {
        if (value) {
          if (element.id != null) {
            db.deleteSample(element.id!);
            ranSucess += 1;
          }
        }
      });
    });
    return ranSucess == count;
  }
}
