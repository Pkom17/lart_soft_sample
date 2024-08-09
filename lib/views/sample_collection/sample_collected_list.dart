import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/services/lab_service.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/selectable_sample_list_item.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/models/sample_model.dart';

class SampleCollectedList extends StatefulWidget {
  const SampleCollectedList({super.key});

  @override
  State<SampleCollectedList> createState() => _SampleCollectedListState();
}

class _SampleCollectedListState extends State<SampleCollectedList> {
  late Future<List<SampleModel>> futureSamples;
  List<LabModel> labs = [];
  List<int> selectedIndices = [];
  final db = DatabaseHelper();
  final labService = LabService();
  @override
  void initState() {
    super.initState();
    loadLabs();
    futureSamples = SampleService().fetchSampleData();
  }

  Future<void> refreshData() async {
    await loadLabs();
    setState(() {
      futureSamples = SampleService().fetchSampleData();
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
          "Les échantillons collectés en transit",
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
                      item: sample,
                      destinationLab: destinationLab,
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
                        _showOptionsDialog(context, sample.sampleId!);
                        setState(() {
                          if (!selectedIndices.contains(index)) {
                            selectedIndices.add(index);
                          }
                        });
                      },
                    );
                    // return SampleListItem(
                    //   item: snapshot.data![index],
                    //   onTap: () {},
                    // );
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
                  SampleService().deleteSample(itemId).then((value) => {
                        if (value)
                          {
                            selectedIndices.clear(),
                            refreshData(),
                            Navigator.pop(context),
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Suppression effectuée"),
                              backgroundColor: Colors.green.shade400,
                              behavior: SnackBarBehavior.floating,
                            )),
                          }
                        else
                          {
                            Utils.showAlertDialog(
                                context, "Erreur lors de la suppression"),
                          }
                      });
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.arrow_forward),
              //   title: const Text('Transférer'),
              //   onTap: () async {
              //     List<SampleModel> samples = await futureSamples;
              //     SampleModel theSample = samples
              //         .firstWhere((element) => element.sampleId == itemId);
              //     List<SampleModel> samplesToTransfer = samples
              //         .where(
              //             (sample) => selectedIndices.contains(sample.sampleId))
              //         .toList();
              //     await Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => TransferToLab(
              //               mileage: theSample.collectionStartMileage!,
              //               samples: samplesToTransfer,
              //               selectedLab: 0,
              //             )));
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
