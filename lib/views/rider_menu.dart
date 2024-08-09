import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/views/result_collection/choose_circuit_for_result.dart';
import 'package:dno_app/views/sample_collection/choose_lab.dart';
import 'package:dno_app/views/result_collection/choose_lab_for_result.dart';
import 'package:dno_app/views/sample_collection/sample_collected_list.dart';
import 'package:dno_app/views/sample_collection/sample_collected_local_list.dart';
import 'package:dno_app/views/sample_collection/choose_circuit.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/views/drawer.dart';

class RiderMenu extends StatefulWidget {
  final UserModel? profile;
  const RiderMenu({super.key, this.profile});

  @override
  State<RiderMenu> createState() => _AboutState();
}

class _AboutState extends State<RiderMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        profile: widget.profile,
      ),
      appBar: AppBar(
        title: const Text(
          "Menu Convoyeur",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SizedBox(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                '1- Collecter des échantillons',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text(
                  "Collecter des échantillons sur site ou au labo relais"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ChooseCircuit(profile: widget.profile)));
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            ListTile(
              title: const Text(
                '2- Déposer des échantillons',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle:
                  const Text("Transmettre des échantillons au laboratoire"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChooseLab(profile: widget.profile)));
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            ListTile(
              title: const Text(
                '3- Données en attente de chargement',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text(
                  "Liste des échantillons collectés non synchronisés"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SampleCollectedLocalList()));
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            ListTile(
              title: const Text(
                '4- Liste des échantillons collectés',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text(
                  "Liste des échantillons en attente d'acheminement"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SampleCollectedList()));
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            ListTile(
              title: const Text(
                '5- Collecter des résultats',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text(
                  "Récupérer des résultats disponibles au laboratoire"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChooseLabForResult()));
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            ListTile(
              title: const Text(
                '6- Déposer des résultats',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text("Transmettre des résultats sur un site"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChooseCircuitForResult()));
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
