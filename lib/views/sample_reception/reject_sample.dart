import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/rejection_type_model.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/views/sample_reception/sample_reception.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/utils/utils.dart';

class RejectSample extends StatefulWidget {
  final SampleModel sampleModel;
  const RejectSample({super.key, required this.sampleModel});

  @override
  State<RejectSample> createState() => _RejectSampleState();
}

class _RejectSampleState extends State<RejectSample> {
  final rejectSampleFormKey = GlobalKey<FormState>();
  final _patientIdentifierController = TextEditingController();
  final _rejectionCommentController = TextEditingController();
  // final _sampleIdentifierController = TextEditingController();
  final _collectionDateController = TextEditingController();
  final _siteNameController = TextEditingController();
  final _sampleTypeController = TextEditingController();

  List<RejectionTypeModel> rejectionTypes = [];
  int? selectedLab;
  int? selectedRejectionType;
  var db = DatabaseHelper();
  bool isSubmitting = false;

  Future<void> loadRejectionTypeList() async {
    final db = DatabaseHelper();
    rejectionTypes = await db.retrieveAllRejectionTypes();
    //insert empty element
    RejectionTypeModel emptyType = RejectionTypeModel(id: 0, name: " ");
    rejectionTypes.insert(0, emptyType);
    setState(() {
      // Update the state after loading the facilities
    });
  }

  @override
  void initState() {
    super.initState();
    loadRejectionTypeList();
    _initializeData();
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

  clear() async {
    setState(() {
      selectedRejectionType = null;
      _rejectionCommentController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rejeter un échantillon",
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
            key: rejectSampleFormKey,
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
                      hintText: "Site de collecte",
                      labelText: "Site de collecte",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
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
                  // const SizedBox(
                  //   height: 20,
                  // ),
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
                    controller: _collectionDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Date de prélèvement",
                      labelText: "Date de prélèvement",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // DropdownButtonFormField(
                  //   // validator: (value) {
                  //   //   if (value == 0 || value == null) {
                  //   //     return "Obligatoire";
                  //   //   }
                  //   //   return null;
                  //   // },
                  //   decoration: const InputDecoration(
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  //     border: OutlineInputBorder(),
                  //     hintText: "Raison du rejet",
                  //     labelText: "Raison du rejet",
                  //   ),
                  //   value: selectedLab,
                  //   icon: const Icon(Icons.keyboard_arrow_down),
                  //   items: rejectionTypes.map((value) {
                  //     return DropdownMenuItem(
                  //       value: value.id,
                  //       child: Text(value.name!),
                  //     );
                  //   }).toList(),
                  //   onChanged: (newValue) {
                  //     setState(() {
                  //       selectedRejectionType = newValue;
                  //     });
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  TextFormField(
                    controller: _rejectionCommentController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Obligatoire";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Raison du rejet",
                      labelText: "Raison du rejet",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                                          if (rejectSampleFormKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isSubmitting = true;
                                            });
                                            SampleModel sampleModel =
                                                widget.sampleModel;
                                            sampleModel.rejectionComment =
                                                _rejectionCommentController
                                                    .text;
                                            sampleModel.rejectionTypeId =
                                                selectedRejectionType;

                                            SampleService sampleService =
                                                SampleService();
                                            sampleService
                                                .postSampleData(
                                                    sampleModel,
                                                    SampleActionKeys
                                                        .REJECT_SAMPLE)
                                                .then((value) => {
                                                      if (value)
                                                        {
                                                          Utils.showAlertDialog(
                                                              context,
                                                              "Mise à jour effectuée"),
                                                          clear(),
                                                        }
                                                    })
                                                .onError(
                                                    (error, stackTrace) => {
                                                          Utils.showErrorSnackBar(
                                                              context,
                                                              "Erreur lors de la mise à jour "),
                                                        });
                                            clear();
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
