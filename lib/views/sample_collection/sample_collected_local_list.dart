import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/utils/selectable_sample_list_item.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/models/sample_model.dart';

class SampleCollectedLocalList extends StatefulWidget {
  const SampleCollectedLocalList({super.key});

  @override
  State<SampleCollectedLocalList> createState() =>
      _SampleCollectedLocalListState();
}

class _SampleCollectedLocalListState extends State<SampleCollectedLocalList> {
  late Future<List<SampleModel>> futureSamples;
  List<int> selectedIndices = [];
  List<LabModel> labs = [];
  final db = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    loadLabs();
    final db = DatabaseHelper();
    futureSamples = db.retrieveAllSamples();
  }

  Future<void> refreshData() async {
    await loadLabs();
    setState(() {
      final db = DatabaseHelper();
      futureSamples = db.retrieveAllSamples();
    });
  }

  Future<void> loadLabs() async {
    final db = DatabaseHelper();
    labs = await db.retrieveAllLabs();
  }

  @override
  Widget build(BuildContext context) {
    loadLabs();
    return Scaffold(
      //drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(
          "Les échantillons collectés non synchronisés",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.purple,
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
                    final isSelected = selectedIndices.contains(index);
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
                          if (selectedIndices.contains(index)) {
                            selectedIndices.remove(index);
                          }
                        });
                      },
                      isChecked: isSelected,
                      onLongPress: () {
                        selectedIndices.clear();
                        _showOptionsDialog(context, sample.id!);
                        setState(() {
                          if (!selectedIndices.contains(index)) {
                            selectedIndices.add(index);
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

  void _showOptionsDialog(BuildContext context, int itemId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Supprimer'),
                onTap: () {
                  // Implement update logic here
                  final db = DatabaseHelper();
                  db.deleteSample(itemId).then((value) => {
                        refreshData(),
                        Navigator.pop(context),
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
