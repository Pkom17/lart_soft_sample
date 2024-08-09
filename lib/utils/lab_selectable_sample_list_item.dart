import 'package:flutter/material.dart';
import 'package:dno_app/models/sample_model.dart';

class LabSelectableSampleListItem extends StatelessWidget {
  final SampleModel item;
  final String requesterSiteName;
  final VoidCallback onTap;
  final bool isChecked;
  final VoidCallback onLongPress;

  const LabSelectableSampleListItem({
    super.key,
    required this.requesterSiteName,
    required this.item,
    required this.onTap,
    required this.isChecked,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: isChecked
              ? const BoxDecoration(
                  color: Colors.grey,
                  border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 210, 151, 218), width: 2),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)))
              : const BoxDecoration(
                  color: Colors.transparent,
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
                'Site de demande : $requesterSiteName',
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
