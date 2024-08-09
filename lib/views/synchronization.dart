import 'package:dno_app/services/setting_service.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:flutter/material.dart';

class Synchronization extends StatefulWidget {
  const Synchronization({super.key});

  @override
  State<Synchronization> createState() => _SynchronizationState();
}

class _SynchronizationState extends State<Synchronization> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Synchronisation",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
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
                'Métadonnées',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle:
                  const Text("Mettre à jour les métadonnées de l'application"),
              onTap: () async {
                await SettingService().refreshMetaData(context);
                Utils.showAlertDialog(context, "Metadonnées mises à jour");
              },
            ),
            Divider(
              color: Colors.purple[100],
              height: 5,
            ),
            ListTile(
              title: const Text(
                'Données sur les échantillons',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text(
                  "Mettre à jour les données saisies sur le serveur"),
              onTap: () async {
                bool res = await SettingService().uploadData();
                if (res) {
                  Utils.showAlertDialog(context, "Données synchronisées");
                } else {
                   Utils.showAlertDialog(context, "Erreur lors de la synchronisation des données");
                }
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
