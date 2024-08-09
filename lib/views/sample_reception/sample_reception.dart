import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/lab_model.dart';
import 'package:dno_app/services/sample_service.dart';
import 'package:dno_app/utils/lab_selectable_sample_list_item.dart';
import 'package:dno_app/views/sample_reception/accept_sample.dart';
import 'package:dno_app/views/sample_reception/reject_sample.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/models/sample_model.dart';

class SampleReception extends StatefulWidget {
  const SampleReception({super.key});

  @override
  State<SampleReception> createState() => _SampleReceptionState();
}

class _SampleReceptionState extends State<SampleReception> {
  late Future<List<SampleModel>> futureSamples = Future.value([]);
  List<LabModel> labs = [];
  List<int> selectedIndices = [];
  final db = DatabaseHelper();
  int selectedLab = 0;

  @override
  void initState() {
    super.initState();
    selectedIndices.clear();
    _initializeFutureSamples();
    setState(() {});
  }

  Future<void> _initializeFutureSamples() async {
    LabModel lab =
        await db.retrieveFirstLab() ?? LabModel(id: 0, name: "", labType: "");
    selectedLab = lab.id ?? 0;
    setState(() {
      futureSamples = SampleService().fetchDeliveredSample(selectedLab);
    });
  }

  Future<void> refreshData() async {
    selectedIndices.clear();
    setState(() {
      futureSamples = SampleService().fetchDeliveredSample(selectedLab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(
          "Réceptionner un échantillon",
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

                    return LabSelectableSampleListItem(
                      item: sample,
                      requesterSiteName: sample.requesterSiteName ?? "",
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
                        _showOptionsDialog(context, sample);
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

  void _showOptionsDialog(BuildContext context, SampleModel item) async {
    //LabModel? lab = await db.getLab(selectedLab);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.check),
                title: const Text('Conforme'),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AcceptSample(
                            sampleModel: item,
                          )));
                },
              ),
              ListTile(
                leading: const Icon(Icons.not_interested),
                title: const Text('Non-conforme'),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RejectSample(
                            sampleModel: item,
                          )));
                },
              ),
            ],
          ),
        );
      },
    ).then((value) => refreshData());
  }
}
