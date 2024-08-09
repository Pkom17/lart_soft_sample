import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/services/circuit_service.dart';
import 'package:dno_app/services/lab_service.dart';
import 'package:dno_app/services/rejection_type_service.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/services/site_service.dart';
import 'package:dno_app/services/user_service.dart';
import 'package:flutter/widgets.dart';

class SettingService {
  String apiURL = "";
  String userName = "";
  String userPassword = "";
  final db = DatabaseHelper();

  Future<void> refreshMetaData(BuildContext context) async {
    await UserService().fetchUserData(context);
    await CircuitService().fetchCircuitsData(context);
    await LabService().fetchLabsData(context);
    await SiteService().fetchSitesData(context);
    await RejectionTypeService().fetchRejectionTypeData(context);
  }

  Future<bool> uploadData() async {
    return await SampleService().postStoredSampleData();
  }
}
