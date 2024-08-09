import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/models/site_model.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/views/sample_collection/choose_site.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectSample extends StatefulWidget {
  const CollectSample({super.key});

  @override
  State<CollectSample> createState() => _CollectSampleState();
}

class _CollectSampleState extends State<CollectSample> {
  final collectSampleFormKey = GlobalKey<FormState>();
  final _patientIdentifierController = TextEditingController();
  // final _sampleIdentifierController = TextEditingController();
  final _collectionDateController = TextEditingController();
  final _collectionTimeController = TextEditingController();
  final siteNameController = TextEditingController();

  final List<String> sampleTypes = [
    "BI",
    "BS",
    "CV",
    "EID",
    "TB",
    "HPV",
  ];
  String sampleTypeSelected = "BI";
  List<LabModel> labs = [];
  int? selectedLab;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var db = DatabaseHelper();
  bool isSubmitting = false;

  clear() async {
    _patientIdentifierController.text = "";
    // _sampleIdentifierController.text = "";
    _collectionDateController.text = "";
    _collectionTimeController.text = "";
  }

  Future<void> loadLabs() async {
    final db = DatabaseHelper();
    labs = await db.retrieveAllLabs();
    //insert empty element
    LabModel emptyLab = LabModel(id: 0, labType: "", name: " ");
    labs.insert(0, emptyLab);
    setState(() {
      // Update the state after loading the facilities
    });
  }

  @override
  void initState() {
    super.initState();
    loadLabs();
    _prefs.then((SharedPreferences prefs) async {
      var storedSelectedSite =
          prefs.getInt(SharedPreferencesKeys.selectedSiteId);

      if (storedSelectedSite == null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const ChooseSite()));
      } else {
        SiteModel? siteModel = await db.getsite(storedSelectedSite);
        siteNameController.text = siteModel?.name ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enregistrer un nouvel échantillon",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 245, 243, 243)),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.purple,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Form(
            key: collectSampleFormKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: siteNameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Site",
                      labelText: "Site de collecte",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // TextFormField(
                  //   controller: _sampleIdentifierController,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Obligatoire";
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  //     border: OutlineInputBorder(),
                  //     hintText: "Identifiant échantillon",
                  //     labelText: "Identifiant échantillon",
                  //     suffixIcon: IconButton(
                  //         onPressed: () async {},
                  //         icon: const Icon(Icons.qr_code)),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Obligatoire";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Type d'échantillon",
                      labelText: "Type d'échantillon",
                    ),
                    value: sampleTypeSelected,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: sampleTypes.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        sampleTypeSelected = newValue!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _patientIdentifierController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Obligatoire";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Code Patient",
                      labelText: "Code Patient",
                      suffixIcon: IconButton(
                          onPressed: () async {},
                          icon: const Icon(Icons.qr_code)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _collectionDateController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Obligatoire";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: const OutlineInputBorder(),
                      hintText: "Date de prélèvement",
                      labelText: "Date de prélèvement",
                      suffixIcon: IconButton(
                          onPressed: () async {
                            final DateTime? collectionDate =
                                await showDatePicker(
                                    locale: const Locale('fr', 'FR'),
                                    context: context,
                                    firstDate: DateTime.now().add(
                                        const Duration(days: 365 * 120 * -1)),
                                    lastDate: DateTime.now());
                            if (collectionDate == null) return;
                            final formattedDate =
                                DateFormat("dd/MM/yyyy").format(collectionDate);
                            setState(() {
                              _collectionDateController.text =
                                  formattedDate.toString();
                            });
                          },
                          icon: const Icon(Icons.calendar_month)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _collectionTimeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Obligatoire";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: const OutlineInputBorder(),
                      hintText: "Heure de prélèvement",
                      labelText: "Heure de prélèvement",
                      suffixIcon: IconButton(
                          onPressed: () async {
                            final TimeOfDay? collectionTime =
                                await showTimePicker(
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              },
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            setState(() {
                              if (collectionTime == null) return;
                              _collectionTimeController.text =
                                  ('${collectionTime.hour}:${collectionTime.minute}');
                            });
                          },
                          icon: const Icon(Icons.watch)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Labo de destination",
                      labelText: "Labo de destination",
                    ),
                    value: selectedLab,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: labs.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(value.name!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLab = newValue;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.deepOrange),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              TextButton(
                                  onPressed: () async {
                                    await clear();
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.remove(
                                        SharedPreferencesKeys.selectedSiteId);

                                    await Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChooseSite()));
                                  },
                                  child: const Text(
                                    "Précédent",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                            ],
                          )),
                      const Spacer(),
                      Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.deepPurple),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: isSubmitting
                                      ? null
                                      : () async {
                                          if (collectSampleFormKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isSubmitting = true;
                                            });
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            SampleModel sampleModel =
                                                SampleModel(
                                                    userId: prefs.getInt(
                                                        SharedPreferencesKeys
                                                            .userId),
                                                    circuitId: prefs.getInt(
                                                        SharedPreferencesKeys
                                                            .selectedCircuitId),
                                                    siteId: prefs.getInt(
                                                        SharedPreferencesKeys
                                                            .selectedSiteId),
                                                    destinationLabId:
                                                        selectedLab,
                                                    status: SampleActionKeys
                                                        .COLLECT_SAMPLE_ON_SITE,
                                                    patientIdentifier:
                                                        _patientIdentifierController
                                                            .text,
                                                    collectionDate:
                                                        '${_collectionDateController.text} ${_collectionTimeController.text}',
                                                    sampleType:
                                                        sampleTypeSelected,
                                                    collectionStartMileage:
                                                        prefs.getInt(
                                                      SharedPreferencesKeys
                                                          .mileage,
                                                    ));

                                            SampleService sampleService =
                                                SampleService();
                                            sampleService
                                                .postSampleData(
                                                    sampleModel,
                                                    SampleActionKeys
                                                        .COLLECT_SAMPLE_ON_SITE)
                                                .then((value) => {
                                                      if (value)
                                                        {
                                                          Utils.showAlertDialog(
                                                              context,
                                                              "Echantillon ajouté avec succès"),
                                                          clear(),
                                                        }
                                                      else
                                                        {
                                                          db
                                                              .createSample(
                                                                  sampleModel)
                                                              .then((value) => {
                                                                    if (value >
                                                                        0)
                                                                      {
                                                                        Utils.showAlertDialog(
                                                                            context,
                                                                            "Echantillon sauvegardé localement"),
                                                                        clear(),
                                                                      }
                                                                    else
                                                                      {
                                                                        Utils.showAlertDialog(
                                                                            context,
                                                                            "Erreur lors de l'enregistrement"),
                                                                      }
                                                                  }),
                                                        }
                                                    });
                                            setState(() {
                                              isSubmitting =
                                                  false; // Reset submitting state
                                            });
                                          }
                                        },
                                  child: const Text(
                                    "Sauvegarder",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.save,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
