import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:dno_app/views/result_collection/collect_result.dart';
import 'package:dno_app/views/rider_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseLabForResult extends StatefulWidget {
  final UserModel? profile;
  const ChooseLabForResult({super.key, this.profile});

  @override
  State<ChooseLabForResult> createState() => _ChooseLabForResultState();
}

clear() async {}

//controller
TextEditingController mileageController = TextEditingController();

class _ChooseLabForResultState extends State<ChooseLabForResult> {
  final labResultFormKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<LabModel> labs = [];
  int? selectedLab;
  int? mileage;
  @override
  void initState() {
    super.initState();
    loadLabs();
    _prefs.then((SharedPreferences prefs) {
      selectedLab = prefs.getInt(SharedPreferencesKeys.selectedLabId) ?? 0;
    });
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
      // drawer: NavDrawer(
      //   profile: widget.profile,
      // ),
      appBar: AppBar(
        title: const Text(
          "Collecter des résultats",
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
            key: labResultFormKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text(
                      "Sélectionner un labo:",
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
                    height: 12,
                  ),
                  TextFormField(
                    controller: mileageController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Obligatoire";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "kilométrage arrivée au laboratoire",
                      labelText: "kilométrage arrivée au laboratoire",
                    ),
                  ),
                  const SizedBox(
                    height: 25,
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
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.remove(
                                        SharedPreferencesKeys.selectedLabId);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RiderMenu()));
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
                                    if (labResultFormKey.currentState!
                                        .validate()) {
                                      if (selectedLab != null) {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        await prefs.setInt(
                                            SharedPreferencesKeys.selectedLabId,
                                            selectedLab!);
                                        await prefs.setInt(
                                            SharedPreferencesKeys.mileage,
                                            int.parse(mileageController.text));
                                        int storedSelectedLab = await prefs
                                                .getInt(SharedPreferencesKeys
                                                    .selectedLabId) ??
                                            0;

                                        await Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                                builder: (context) =>
                                                    CollectResult(
                                                        labId:
                                                            storedSelectedLab,
                                                        mileage:
                                                            mileage ?? 0)));
                                      } else {
                                        Utils.showErrorSnackBar(context,
                                            "Vous devez d'abord sélectionner un laboratoire");
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Suivant",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
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
