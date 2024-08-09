import 'package:dno_app/models/circuit_model.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/rejection_type_model.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/models/site_model.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "sample_tracker.db";

  String userTable =
      "CREATE TABLE user(user_id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL, firstname TEXT NOT NULL, "
      "lastname TEXT NOT NULL, phonecontact TEXT NOT NULL,password TEXT NOT NULL, isactive INTEGER DEFAULT 0, "
      "usertype TEXT)";

  String labTable =
      "CREATE TABLE lab(id INTEGER PRIMARY KEY, name TEXT, labType TEXT)";

  String circuitTable =
      "CREATE TABLE circuit(id INTEGER PRIMARY KEY, name TEXT)";

  String siteTable =
      "CREATE TABLE site(id INTEGER PRIMARY KEY, name TEXT,dhisCode TEXT, circuitId INTEGER)";

  String rejectionTypeTable =
      "CREATE TABLE rejection_type(id INTEGER PRIMARY KEY, name TEXT)";

  String sampleTable =
      "create table sample (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, sampleId INTEGER, circuitId INTEGER,"
      " sampleRetrievingId INTEGER, rejectionTypeId INTEGER, rejectionComment TEXT, siteId, INTEGER, hubId INTEGER, "
      " labId INTEGER, patientIdentifier TEXT, sampleIdentifier TEXT, circuitNumber TEXT, mileage INTEGER,"
      " collectionDate TEXT, deliveredAtHubDate TEXT, deliveredAtReferenceLabDate TEXT, acceptedAtHubDate TEXT, "
      " acceptedAtReferenceLabDate TEXT,sampleType TEXT, labNumber TEXT, resultCollectionDate TEXT, resultDeliveryDate TEXT, status TEXT,"
      " destinationLabId INTEGER, requesterSiteName TEXT,destinationLabName TEXT,analysisCompletedDate TEXT, analysisReleasedDate TEXT, "
      " analysisResultReportedDate TEXT, rejectionDate TEXT, collectionStartMileage TEXT, collectionEndMileage TEXT, resultStartMileage TEXT,"
      " resultEndMileage TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(userTable);
        await db.execute(labTable);
        await db.execute(circuitTable);
        await db.execute(siteTable);
        await db.execute(rejectionTypeTable);
        await db.execute(sampleTable);
      },
    );
  }

  Future<int> createUser(UserModel user) async {
    final Database db = await initDB();
    return db.insert(
      "user",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> login(UserModel user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from  user where username = '${user.userName}' AND password = '${user.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> signup(UserModel user) async {
    final Database db = await initDB();
    return db.insert('user', user.toMap());
  }

  Future<UserModel?> getUser(String userName) async {
    final Database db = await initDB();
    var res =
        await db.query("user", where: "username = ?", whereArgs: [userName]);
    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }

  //sample
  Future<int> createSample(SampleModel sample) async {
    final Database db = await initDB();
    return db.insert(
      "sample",
      sample.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<SampleModel?> getSample(int sampleId) async {
    final Database db = await initDB();
    var res = await db.query("sample", where: "id = ?", whereArgs: [sampleId]);
    if (res.isNotEmpty) {
      return SampleModel.fromJson(res.first);
    }
    return null;
  }

  Future<List<SampleModel>> retrieveAllSamples() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query('sample');
    return queryResult.map((e) => SampleModel.fromJson(e)).toList();
  }

  Future<void> deleteSample(int id) async {
    final Database db = await initDB();
    await db.delete(
      'sample',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //lab
  Future<int> createLab(LabModel lab) async {
    final Database db = await initDB();
    return db.insert(
      "lab",
      lab.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteAllLabs() async {
    final Database db = await initDB();
    return db.delete("lab");
  }

  Future<LabModel?> getLab(int labId) async {
    final Database db = await initDB();
    var res = await db.query("lab", where: "id = ?", whereArgs: [labId]);
    if (res.isNotEmpty) {
      return LabModel.fromJson(res.first);
    }
    return null;
  }

  Future<List<LabModel>> retrieveAllLabs() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query('lab');
    return queryResult.map((e) => LabModel.fromJson(e)).toList();
  }

  Future<LabModel?> retrieveFirstLab() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('lab', limit: 1);
    return queryResult.isNotEmpty ? LabModel.fromJson(queryResult.first) : null;
  }

  Future<List<LabModel>> retrieveAllReferenceLabs() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('lab', where: "id = ?", whereArgs: ["PLATEFORME"]);
    return queryResult.map((e) => LabModel.fromJson(e)).toList();
  }

  Future<List<LabModel>> retrieveAllHubs() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('lab', where: "id = ?", whereArgs: ["RELAIS"]);
    return queryResult.map((e) => LabModel.fromJson(e)).toList();
  }

  //circuit
  Future<int> createCircuit(CircuitModel circuit) async {
    final Database db = await initDB();
    return db.insert(
      "circuit",
      circuit.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteAllCircuits() async {
    final Database db = await initDB();
    return db.delete("circuit");
  }

  Future<CircuitModel?> getCircuit(int circuitId) async {
    final Database db = await initDB();
    var res =
        await db.query("circuit", where: "id = ?", whereArgs: [circuitId]);
    if (res.isNotEmpty) {
      return CircuitModel.fromJson(res.first);
    }
    return null;
  }

  Future<List<CircuitModel>> retrieveAllCircuits() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query('circuit');
    return queryResult.map((e) => CircuitModel.fromJson(e)).toList();
  }

  //site
  Future<int> createSite(SiteModel site) async {
    final Database db = await initDB();
    return db.insert(
      "site",
      site.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteAllSites() async {
    final Database db = await initDB();
    return db.delete("site");
  }

  Future<SiteModel?> getsite(int siteId) async {
    final Database db = await initDB();
    var res = await db.query("site", where: "id = ?", whereArgs: [siteId]);
    if (res.isNotEmpty) {
      return SiteModel.fromJson(res.first);
    }
    return null;
  }

  Future<List<SiteModel>> retrieveAllSites() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query('site');
    return queryResult.map((e) => SiteModel.fromJson(e)).toList();
  }

  Future<List<SiteModel>> retrieveSitesByCircuit(int circuitId) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('site', where: "circuitId = ?", whereArgs: [circuitId]);
    return queryResult.map((e) => SiteModel.fromJson(e)).toList();
  }

//rejectionType
  Future<int> createRejectionType(RejectionTypeModel type) async {
    final Database db = await initDB();
    return db.insert("rejection_type", type.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteAllRejectionTypes() async {
    final Database db = await initDB();
    return db.delete("rejection_type");
  }

  Future<RejectionTypeModel?> getRejectionType(int siteId) async {
    final Database db = await initDB();
    var res =
        await db.query("rejection_type", where: "id = ?", whereArgs: [siteId]);
    if (res.isNotEmpty) {
      return RejectionTypeModel.fromJson(res.first);
    }
    return null;
  }

  Future<List<RejectionTypeModel>> retrieveAllRejectionTypes() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('rejection_type');
    return queryResult.map((e) => RejectionTypeModel.fromJson(e)).toList();
  }
}
