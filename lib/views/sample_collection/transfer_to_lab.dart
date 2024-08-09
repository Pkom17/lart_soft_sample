import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:dno_app/views/sample_collection/deliver_sample.dart';
import 'package:flutter/material.dart';

class TransferToLab extends StatefulWidget {
  final UserModel? profile;
  final int mileage;
  final int selectedLab;
  final List<SampleModel> samples;
  const TransferToLab(
      {super.key,
      this.profile,
      required this.mileage,
      required this.selectedLab,
      required this.samples});

  @override
  State<TransferToLab> createState() => _TransferToLabState();
}

clear() async {}

class _TransferToLabState extends State<TransferToLab> {
  final transferLabFormKey = GlobalKey<FormState>();
  List<LabModel> labs = [];
  int newSelectedLab = 0;
  @override
  void initState() {
    super.initState();
    loadLabs();
  }

  Future<void> loadLabs() async {
    final db = DatabaseHelper();
    labs = await db.retrieveAllLabs();
    labs.insert(0, LabModel(id: 0, name: "", labType: ""));
    setState(() {
      // Update the state after loading the facilities
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transférer des échantillons",
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
            key: transferLabFormKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text(
                      "Sélectionner un nouveau labo:",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  ),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == 0) {
                        return "Obligatoire";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Labo",
                      labelText: "Labo",
                    ),
                    value: 0,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: labs.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(value.name!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        newSelectedLab = newValue ?? 0;
                      });
                    },
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
                            color: Colors.deepOrange,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => DeliverSample(
                                                  labId: widget.selectedLab,
                                                  mileage: widget.mileage,
                                                )));
                                  },
                                  child: const Text(
                                    "Retour",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
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
                                  onPressed: () async {
                                    if (transferLabFormKey.currentState!
                                        .validate()) {
                                      if (newSelectedLab != 0) {
                                        widget.samples.forEach((element) {
                                          element.destinationLabId =
                                              newSelectedLab;
                                          SampleService()
                                              .postSampleData(
                                                  element,
                                                  SampleActionKeys
                                                      .TRANSFER_SAMPLE)
                                              .then((value) => {
                                                    if (value)
                                                      {
                                                        Utils.showSuccessSnackBar(
                                                            context,
                                                            "Données mises à jour avec succès"),
                                                      }
                                                  });
                                        });
                                      } else {
                                        Utils.showErrorSnackBar(context,
                                            "Vous devez d'abord sélectionner un laboratoire");
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Sauvegarder",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.save,
                                color: Colors.white,
                                size: 24,
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
