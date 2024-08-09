import 'package:dno_app/models/lab_model.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/models/sample_model.dart';

class SampleListItem extends StatelessWidget {
  final SampleModel item;
  final LabModel destinationLab;
  final VoidCallback onTap;

  const SampleListItem(
      {super.key,
      required this.item,
      required this.destinationLab,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color.fromARGB(255, 210, 151, 218), width: 2),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.sampleType,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Identifiant Patient: ${item.patientIdentifier}',
                style: const TextStyle(fontSize: 17.0),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Prelévé le ${item.collectionDate}',
                style: const TextStyle(
                    fontSize: 15.0, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Destinatation: ${destinationLab.name}',
                style: const TextStyle(
                    fontSize: 15.0, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
