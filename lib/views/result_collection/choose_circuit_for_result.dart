import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/circuit_model.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:dno_app/views/result_collection/choose_site_for_result.dart';
import 'package:dno_app/views/rider_menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseCircuitForResult extends StatefulWidget {
  final UserModel? profile;
  const ChooseCircuitForResult({super.key, this.profile});

  @override
  State<ChooseCircuitForResult> createState() => _ChooseCircuitForResultState();
}

clear() async {}

class _ChooseCircuitForResultState extends State<ChooseCircuitForResult> {
  final circuitFormKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<CircuitModel> circuits = [];
  int? selectedCircuit;
  @override
  void initState() {
    super.initState();
    loadCircuits();
    _prefs.then((SharedPreferences prefs) {
      selectedCircuit = prefs.getInt(SharedPreferencesKeys.selectedCircuitId);
      // if (storedSelectedCircuit != null) {
      //   // forward to site selection
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (context) => const ChooseSite()));
      // }
    });
  }

  Future<void> loadCircuits() async {
    final db = DatabaseHelper();
    circuits = await db.retrieveAllCircuits();
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
          "Choisir le circuit",
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
            key: circuitFormKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text(
                      "Sélectionner un circuit:",
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
                      hintText: "Circuit",
                      labelText: "Circuit",
                    ),
                    value: selectedCircuit,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: circuits.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(value.name!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCircuit = newValue;
                      });
                    },
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
                                    await prefs.remove(SharedPreferencesKeys
                                        .selectedCircuitId);
                                    await prefs.remove(
                                        SharedPreferencesKeys.selectedSiteId);
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
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    if (selectedCircuit != null) {
                                      await prefs.setInt(
                                          SharedPreferencesKeys
                                              .selectedCircuitId,
                                          selectedCircuit!);
                                      await Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChooseSiteForResult()));
                                    } else {
                                      Utils.showErrorSnackBar(context,
                                          "Veuillez d'abord sélectionner un circuit");
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
