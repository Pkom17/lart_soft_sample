import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/views/sample_reception/sample_received%20list.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportResult extends StatefulWidget {
  final SampleModel sampleModel;
  const ReportResult({super.key, required this.sampleModel});

  @override
  State<ReportResult> createState() => _ReportResultState();
}

class _ReportResultState extends State<ReportResult> {
  final acceptSampleFormKey = GlobalKey<FormState>();
  final _sampleTypeController = TextEditingController();
  final _patientIdentifierController = TextEditingController();
  // final _sampleIdentifierController = TextEditingController();
  final _labNumberController = TextEditingController();
  final _collectionDateController = TextEditingController();
  final _siteNameController = TextEditingController();
  final _analysisCompletedDateController = TextEditingController();
  final _analysisReleasedDateController = TextEditingController();
  final _analysisCompletedTimeController = TextEditingController();
  final _analysisReleasedTimeController = TextEditingController();

  LabModel? lab;
  List<LabModel> labs = [];
  int? selectedLab;
  var db = DatabaseHelper();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  clear() async {
    _analysisReleasedDateController.text = "";
    _analysisCompletedDateController.text = "";
    _analysisCompletedTimeController.text = "";
    _analysisReleasedTimeController.text = "";
  }

  Future<void> _initializeData() async {
    _siteNameController.text = "${widget.sampleModel.requesterSiteName}";
    _sampleTypeController.text = widget.sampleModel.sampleType;
    _patientIdentifierController.text = widget.sampleModel.patientIdentifier;
    // _sampleIdentifierController.text = widget.sampleModel.sampleIdentifier;
    _collectionDateController.text = widget.sampleModel.collectionDate;
    _labNumberController.text = widget.sampleModel.labNumber ?? "";

    LabModel lab =
        await db.retrieveFirstLab() ?? LabModel(id: 0, name: "", labType: "");
    selectedLab = lab.id ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reporter la disponibilité du résultat",
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
            key: acceptSampleFormKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _siteNameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Site",
                      labelText: "Site de collecte",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // TextFormField(
                  //   controller: _sampleIdentifierController,
                  //   readOnly: true,
                  //   decoration: const InputDecoration(
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  //     border: OutlineInputBorder(),
                  //     hintText: "Identifiant échantillon",
                  //     labelText: "Identifiant échantillon",
                  //   ),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _patientIdentifierController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Code Patient",
                      labelText: "Code Patient",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _collectionDateController,
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Date de prélèvement",
                      labelText: "Date de prélèvement",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _labNumberController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Numéro laboratoire",
                      labelText: "Numéro laboratoire",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _analysisCompletedDateController,
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
                      hintText: "Date de l'analyse",
                      labelText: "Date de l'analyse",
                      suffixIcon: IconButton(
                          onPressed: () async {
                            final DateTime? analysisDate = await showDatePicker(
                                locale: const Locale('fr', 'FR'),
                                context: context,
                                firstDate: DateTime.now()
                                    .add(const Duration(days: 365 * 120 * -1)),
                                lastDate: DateTime.now());
                            if (analysisDate == null) return;
                            final formattedDate =
                                DateFormat("dd/MM/yyyy").format(analysisDate);
                            setState(() {
                              _analysisCompletedDateController.text =
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
                    controller: _analysisCompletedTimeController,
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
                      hintText: "Heure de l'analyse",
                      labelText: "Heure de l'analyse",
                      suffixIcon: IconButton(
                          onPressed: () async {
                            final TimeOfDay? analysisTime =
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
                              if (analysisTime == null) return;
                              _analysisCompletedTimeController.text =
                                  ('${analysisTime.hour}:${analysisTime.minute}');
                            });
                          },
                          icon: const Icon(Icons.watch)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _analysisReleasedDateController,
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
                      hintText: "Date de disponibilité du résultat",
                      labelText: "Date de disponibilité du résultat",
                      suffixIcon: IconButton(
                          onPressed: () async {
                            final DateTime? resultDate = await showDatePicker(
                                locale: const Locale('fr', 'FR'),
                                context: context,
                                firstDate: DateTime.now()
                                    .add(const Duration(days: 365 * 120 * -1)),
                                lastDate: DateTime.now());
                            if (resultDate == null) return;
                            final formattedDate =
                                DateFormat("dd/MM/yyyy").format(resultDate);
                            setState(() {
                              _analysisReleasedDateController.text =
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
                    controller: _analysisReleasedTimeController,
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
                      hintText: "Heure de disponibilité du résultat",
                      labelText: "Heure de disponibilité du résultat",
                      suffixIcon: IconButton(
                          onPressed: () async {
                            final TimeOfDay? resultTime = await showTimePicker(
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
                              if (resultTime == null) return;
                              _analysisReleasedTimeController.text =
                                  ('${resultTime.hour}:${resultTime.minute}');
                            });
                          },
                          icon: const Icon(Icons.watch)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
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
                                                const SampleReceivedList()));
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
                                          if (acceptSampleFormKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isSubmitting = true;
                                            });
                                            // final prefs =
                                            //     await SharedPreferences
                                            //         .getInstance();
                                            SampleModel sampleModel =
                                                widget.sampleModel;
                                            sampleModel.analysisCompletedDate =
                                                '${_analysisCompletedDateController.text} ${_analysisCompletedTimeController.text}';
                                            sampleModel.analysisReleasedDate =
                                                '${_analysisReleasedDateController.text} ${_analysisReleasedTimeController.text}';
                                            SampleService sampleService =
                                                SampleService();
                                            sampleService
                                                .postSampleData(
                                                    sampleModel,
                                                    SampleActionKeys
                                                        .ANALYSIS_DONE)
                                                .then((value) => {
                                                      if (value)
                                                        {
                                                          Utils.showAlertDialog(
                                                              context,
                                                              "Mise à jour effectuée"),
                                                          clear(),
                                                        }
                                                      else
                                                        {
                                                          Utils.showErrorSnackBar(
                                                              context,
                                                              "Erreurs rencontrées"),
                                                        }
                                                    });
                                            setState(() {
                                              isSubmitting =
                                                  false; // Reset submitting state
                                            });
                                          }
                                        },
                                  child: const Text(
                                    "Accepter",
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
