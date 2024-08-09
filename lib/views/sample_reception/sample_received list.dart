import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/SampleActionKeys.dart';
import 'package:dno_app/utils/lab_selectable_sample_list_item.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:dno_app/views/sample_reception/report_result.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/models/sample_model.dart';

class SampleReceivedList extends StatefulWidget {
  const SampleReceivedList({super.key});

  @override
  State<SampleReceivedList> createState() => _SampleReceivedListState();
}

class _SampleReceivedListState extends State<SampleReceivedList> {
  late Future<List<SampleModel>> futureSamples = Future.value([]);
  List<int> selectedIndices = [];
  final db = DatabaseHelper();
  int selectedLab = 0;
  @override
  void initState() {
    super.initState();
    _initializeFutureSamples();
  }

  Future<void> refreshData() async {
    await _initializeFutureSamples();
    setState(() {
      futureSamples = SampleService().fetchSamplesAcceptedInLab(selectedLab);
    });
  }

  Future<void> _initializeFutureSamples() async {
    LabModel lab =
        await db.retrieveFirstLab() ?? LabModel(id: 0, name: "", labType: "");
    selectedLab = lab.id ?? 0;
    setState(() {
      futureSamples = SampleService().fetchSamplesAcceptedInLab(selectedLab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(
          "Les échantillons receptionnés au laboratoire",
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
                    final isSelected = selectedIndices.contains(sample.id);

                    return LabSelectableSampleListItem(
                      item: sample,
                      requesterSiteName: sample.requesterSiteName ?? "",
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportResult(
                                      sampleModel: sample,
                                    )));
                      },
                      isChecked: isSelected,
                      onLongPress: () {},
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
          value: 'done',
          child: const Text('Résultat disponible'),
        ),
        const PopupMenuItem<String>(
          value: 'failed',
          child: const Text('Analyse échouée'),
        ),
      ],
      elevation: 8.0,
    ).then((String? value) {
      if (value == 'failed') {
        // Handle delete option
        _handleFailed(context);
      } else if (value == 'done') {
        // Handle update option
        _handleDone(context);
      }
    });
  }

  void _handleDone(BuildContext context) async {
    // List<SampleModel> samples = await futureSamples;
    // selectedIndices.forEach((selectedSampleId) {
    //   samples.forEach((element) async {
    //     if (element.sampleId == selectedSampleId) {
    //       await SampleService()
    //           .postSampleData(element, SampleActionKeys.ANALYSIS_DONE);
    //       samples.removeWhere((e) {
    //         return e.sampleId == element.sampleId;
    //       });
    //     }
    //   });
    // });

    // selectedIndices.clear();
    // await refreshData();
    // Utils.showSuccessSnackBar(context, "Mise à jour effectuée");

    List<SampleModel> samples = await futureSamples;
    SampleModel selectedSample =
        samples.firstWhere((element) => element.id == selectedIndices.first);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReportResult(
                  sampleModel: selectedSample,
                )));
  }

  void _handleFailed(BuildContext context) async {
    List<SampleModel> samples = await futureSamples;
    selectedIndices.forEach((selectedSampleId) {
      samples.forEach((element) async {
        if (element.sampleId == selectedSampleId) {
          await SampleService()
              .postSampleData(element, SampleActionKeys.ANALYSIS_FAILED);
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
