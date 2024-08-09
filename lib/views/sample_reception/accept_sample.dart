import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/views/sample_reception/sample_reception.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptSample extends StatefulWidget {
  final SampleModel sampleModel;
  const AcceptSample({super.key, required this.sampleModel});

  @override
  State<AcceptSample> createState() => _AcceptSampleState();
}

class _AcceptSampleState extends State<AcceptSample> {
  final acceptSampleFormKey = GlobalKey<FormState>();
  final _sampleTypeController = TextEditingController();
  final _patientIdentifierController = TextEditingController();
  // final _sampleIdentifierController = TextEditingController();
  final _labNumberController = TextEditingController();
  final _collectionDateController = TextEditingController();
  final _siteNameController = TextEditingController();

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
    _labNumberController.text = "";
  }

  Future<void> _initializeData() async {
    _siteNameController.text = "${widget.sampleModel.requesterSiteName}";
    _sampleTypeController.text = widget.sampleModel.sampleType;
    _patientIdentifierController.text = widget.sampleModel.patientIdentifier;
    // _sampleIdentifierController.text = widget.sampleModel.sampleIdentifier;
    _collectionDateController.text = widget.sampleModel.collectionDate;

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
          "Accepter l\'échantillon",
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
                  // const SizedBox(
                  //   height: 10,
                  // ),
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
                    height: 20,
                  ),
                  TextFormField(
                    controller: _sampleTypeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Type d'échantillon",
                      labelText: "Type d'échantillon",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                    height: 20,
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
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return "Obligatoire";
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: const OutlineInputBorder(),
                      hintText: "Numéro laboratoire",
                      labelText: "Numéro laboratoire",
                      suffixIcon: IconButton(
                          onPressed: () async {},
                          icon: const Icon(Icons.qr_code)),
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
                                                const SampleReception()));
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
                                            SampleModel sampleModel =
                                                widget.sampleModel;
                                            sampleModel.labId = selectedLab;
                                            sampleModel.labNumber =
                                                _labNumberController.text;

                                            SampleService sampleService =
                                                SampleService();
                                            sampleService
                                                .postSampleData(
                                                    sampleModel,
                                                    lab?.labType == "RELAIS"
                                                        ? SampleActionKeys
                                                            .ACCEPT_SAMPLE_AT_HUB
                                                        : SampleActionKeys
                                                            .ACCEPT_SAMPLE_AT_LAB)
                                                .then((value) => {
                                                      if (value)
                                                        {
                                                          Utils.showAlertDialog(
                                                              context,
                                                              "Echantillon accepté"),
                                                          clear(),
                                                        }
                                                      else
                                                        {
                                                          Utils.showErrorSnackBar(
                                                              context,
                                                              "Erreurs rencontrées"),
                                                        }
                                                    })
                                                .onError(
                                                    (error, stackTrace) => {
                                                          Utils.showErrorSnackBar(
                                                              context,
                                                              "Erreur lors de la mise à jour "),
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
