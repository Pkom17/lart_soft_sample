import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/circuit_model.dart';
import 'package:dno_app/models/site_model.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:dno_app/views/sample_collection/collect_sample.dart';
import 'package:dno_app/views/sample_collection/choose_circuit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseSite extends StatefulWidget {
  final UserModel? profile;
  const ChooseSite({super.key, this.profile});

  @override
  State<ChooseSite> createState() => _ChooseSiteState();
}

clear() async {}

//controller
TextEditingController mileageController = TextEditingController();

class _ChooseSiteState extends State<ChooseSite> {
  final siteFormKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController circuitController = TextEditingController();

  List<SiteModel> sites = [];
  int? selectedSite;
  String circuitNumber = "";
  @override
  void initState() {
    super.initState();
    loadSites();
    var db = DatabaseHelper();
    _prefs.then((SharedPreferences prefs) async {
      selectedSite = prefs.getInt(SharedPreferencesKeys.selectedSiteId);

      var storedSelectedCircuit =
          prefs.getInt(SharedPreferencesKeys.selectedCircuitId) ?? 0;
      CircuitModel? circuit = await db.getCircuit(storedSelectedCircuit);
      circuitController.text = circuit?.name ?? "";
    });
  }

  Future<void> loadSites() async {
    final db = DatabaseHelper();
    final prefs = await SharedPreferences.getInstance();
    var storedSelectedCircuit =
        prefs.getInt(SharedPreferencesKeys.selectedCircuitId);
    if (storedSelectedCircuit != null) {
      sites = await db.retrieveSitesByCircuit(storedSelectedCircuit);
      setState(() {
        // Update the state after loading the facilities
      });
    } else {
      //go back to circuit selection
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ChooseCircuit(
                profile: widget.profile,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Commencer à collecter sur un nouveau site",
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
            key: siteFormKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text(
                      "Sélectionner un site de collecte:",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  ),
                  TextFormField(
                    controller: circuitController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Axe:",
                      labelText: "Axe",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
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
                      hintText: "Site de collecte",
                      labelText: "Site de collecte",
                    ),
                    value: selectedSite,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: sites.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(value.name!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSite = newValue;
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
                      hintText: "kilométrage arrivé sur site",
                      labelText: "kilométrage arrivé sur site",
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
                              color: Colors.deepOrange),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChooseCircuit()));
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
                                  onPressed: () async {
                                    if (siteFormKey.currentState!.validate()) {
                                      if (selectedSite != null) {
                                        _prefs.then((SharedPreferences prefs) {
                                          prefs.setInt(
                                              SharedPreferencesKeys
                                                  .selectedSiteId,
                                              selectedSite!);
                                          prefs.setInt(
                                              SharedPreferencesKeys.mileage,
                                              int.parse(
                                                  mileageController.text));
                                        }).then((value) => {
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const CollectSample())),
                                            });
                                      } else {
                                        Utils.showErrorSnackBar(context,
                                            "Vous devez d'abord sélectionner un site");
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
