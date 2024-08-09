import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/selectable_sample_list_item.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliverResult extends StatefulWidget {
  final int selectedSite;
  const DeliverResult({super.key, required this.selectedSite});

  @override
  State<DeliverResult> createState() => _DeliverResultState();
}

class _DeliverResultState extends State<DeliverResult> {
  late Future<List<SampleModel>> futureSamples;
  List<int> selectedIndices = [];
  List<LabModel> labs = [];
  var db = DatabaseHelper();

  clear() async {}

  @override
  void initState() {
    super.initState();
    loadLabs();
    futureSamples =
        SampleService().fetchCollectedResultForSite(widget.selectedSite);
  }

  Future<void> refreshData() async {
    loadLabs();
    setState(() {
      futureSamples =
          SampleService().fetchCollectedResultForSite(widget.selectedSite);
    });
  }

  Future<void> loadLabs() async {
    final db = DatabaseHelper();
    labs = await db.retrieveAllLabs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(
          "Liste des résultats à déposer",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.purple,
        actions: selectedIndices.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Handle menu button press
                    _showMenu(context);
                  },
                ),
              ]
            : [],
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<SampleModel>>(
            future: futureSamples,
            initialData: const [],
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const ListTile(
                  title: Text(
                    "Aucune donnée reçue du serveur ...",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                );
              }

              if (snapshot.data!.isEmpty) {
                return const ListTile(
                  title: Text(
                    "Liste vide ...",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    SampleModel sample = snapshot.data![index];
                    final isSelected =
                        selectedIndices.contains(sample.sampleId);

                    LabModel destinationLab = sample.destinationLabId != null
                        ? labs.firstWhere(
                            (element) => element.id == sample.destinationLabId,
                            orElse: () =>
                                LabModel(id: 0, labType: "", name: ""))
                        : LabModel(id: 0, labType: "", name: "");

                    return SelectableSampleListItem(
                      destinationLab: destinationLab,
                      item: sample,
                      onTap: () {
                        setState(() {
                          if (selectedIndices.contains(sample.sampleId)) {
                            selectedIndices.remove(sample.sampleId);
                          }
                        });
                      },
                      isChecked: isSelected,
                      onLongPress: () {
                        setState(() {
                          if (!selectedIndices.contains(sample.sampleId)) {
                            selectedIndices.add(sample.sampleId ?? 0);
                          }
                        });
                      },
                    );
                  },
                );
              }
            }),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(50, 80, 0, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'deliver',
          child: Text('Déposer des résultats'),
        ),
      ],
      elevation: 8.0,
    ).then((String? value) {
      if (value == 'deliver') {
        _handleDeliver(context);
      }
    });
  }

  void _handleDeliver(BuildContext context) async {
    List<SampleModel> samples = await futureSamples;
    final prefs = await SharedPreferences.getInstance();
    selectedIndices.forEach((selectedSampleId) {
      samples.forEach((element) async {
        if (element.sampleId == selectedSampleId) {
          element.resultEndMileage =
              prefs.getInt(SharedPreferencesKeys.mileage);
          await SampleService()
              .postSampleData(element, SampleActionKeys.DELIVER_RESULT);
          samples.removeWhere((e) {
            return e.sampleId == element.sampleId;
          });
        }
      });
    });

    selectedIndices.clear();
    await refreshData();
    Utils.showSuccessSnackBar(context, "Mise à jour effectuée");
  }
}
