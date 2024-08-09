import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/views/sample_reception/sample_received%20list.dart';
import 'package:dno_app/views/sample_reception/sample_reception.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/views/drawer.dart';

class LabMenu extends StatefulWidget {
  final UserModel? profile;
  const LabMenu({super.key, this.profile});

  @override
  State<LabMenu> createState() => _LabMenuState();
}

class _LabMenuState extends State<LabMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        profile: widget.profile,
      ),
      appBar: AppBar(
        title: const Text(
          "Menu Laboratoire",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SizedBox(
        child: ListView(
          children: [
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            ListTile(
              title: const Text(
                '1- Réceptionner des échantillons',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text(
                  "Receptionner des échantillons, accepter ou rejeter des échantillons"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SampleReception()));
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            ListTile(
              title: const Text(
                '2- Liste des échantillons réceptionnés',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text(
                  "Liste des échantillons acheminés dans votre laboratoire"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SampleReceivedList()));
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            // ListTile(
            //   title: const Text(
            //     '3- Disponibilité de résultats',
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            //   ),
            //   subtitle: const Text(
            //       "Identifier les échantillons dont les résultats sont disponibles"),
            //   trailing: const Icon(Icons.chevron_right),
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const ResultReady()));
            //   },
            // ),
            // Divider(
            //   color: Colors.purple[100],
            //   height: 5,
            // ),
          ],
        ),
      ),
    );
  }
}
