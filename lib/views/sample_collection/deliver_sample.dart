import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/models/sample_model.dart';
import 'package:dno_app/services/lab_service.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/utils/selectable_sample_list_item.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:dno_app/views/sample_collection/choose_lab.dart';
import 'package:dno_app/views/sample_collection/transfer_to_lab.dart';
import 'package:flutter/material.dart';

class DeliverSample extends StatefulWidget {
  final int labId;
  final int mileage;
  const DeliverSample({super.key, required this.labId, required this.mileage});

  @override
  State<DeliverSample> createState() => _DeliverSampleState();
}

class _DeliverSampleState extends State<DeliverSample> {
  late Future<List<SampleModel>> futureSamples;
  List<int> selectedIndices = [];
  List<LabModel> labs = [];
  final db = DatabaseHelper();
  final labService = LabService();

  clear() async {}

  @override
  void initState() {
    super.initState();
    loadLabs();
    selectedIndices.clear();
    if (widget.labId == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ChooseLab()));
    }
    futureSamples = SampleService().fetchSampleForLab(widget.labId);
  }

  Future<void> refreshData() async {
    selectedIndices.clear();
    await loadLabs();
    setState(() {
      futureSamples = SampleService().fetchSampleForLab(widget.labId);
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
          "Liste des échantillons collectés",
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
          child: Text('Déposer des échantillons'),
        ),
        const PopupMenuItem<String>(
          value: 'transfer',
          child: Text('Transférer des échantillons'),
        ),
        // const PopupMenuItem<String>(
        //   value: 'delete',
        //   enabled: false,
        //   child:  Text('Supprimer les échantilllons'),
        // ),
      ],
      elevation: 8.0,
    ).then((String? value) {
      if (value == 'delete') {
        // Handle delete option
        _handleDelete(context);
      } else if (value == 'deliver') {
        // Handle update option
        _handleDeliver(context);
      } else if (value == 'transfer') {
        // Handle update option
        _handleTransfer(context);
      }
    });
  }

  void _handleDelete(BuildContext context) async {
    selectedIndices.forEach((selectedSampleId) async {
      await SampleService().deleteSample(selectedSampleId);
      selectedIndices.remove(selectedSampleId);
    });
    selectedIndices.clear();
    await refreshData();
    Utils.showSuccessSnackBar(context, "Mise à jour effectuée");
  }

  void _handleDeliver(BuildContext context) async {
    LabModel? lab = await db.getLab(widget.labId);
    List<SampleModel> samples = await futureSamples;
    selectedIndices.forEach((selectedSampleId) {
      samples.forEach((element) async {
        if (element.sampleId == selectedSampleId) {
          lab?.labType == "RELAIS"
              ? element.hubId = lab?.id
              : element.labId = lab?.id;
          element.collectionEndMileage = widget.mileage;
          await SampleService().postSampleData(
              element,
              lab?.labType == "RELAIS"
                  ? SampleActionKeys.DELIVER_SAMPLE_AT_HUB
                  : SampleActionKeys.DELIVER_SAMPLE_AT_LAB);
          samples.removeWhere((e) {
            return e.sampleId == element.sampleId;
          });
        }
      });
    });

    await refreshData();
    Utils.showSuccessSnackBar(context, "Mise à jour effectuée");
  }

  void _handleTransfer(context) async {
    List<SampleModel> samples = await futureSamples;
    List<SampleModel> samplesToTransfer = samples
        .where((sample) => selectedIndices.contains(sample.sampleId))
        .toList();
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TransferToLab(
              mileage: widget.mileage,
              samples: samplesToTransfer,
              selectedLab: widget.labId,
            )));
  }
}
