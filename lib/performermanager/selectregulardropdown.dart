import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/datastore.dart';
import '../model/performer/performer.dart';

class SelectRegularDropdown extends StatelessWidget {
  const SelectRegularDropdown(
      {super.key,
      required this.savedPerformer,
      required this.onPerformerSelected});

  final Performer? savedPerformer;
  final ValueChanged<Performer> onPerformerSelected;

  @override
  Widget build(BuildContext context) {
    DataStore dataStore = Provider.of<DataStore>(context, listen: true);
    return FutureBuilder<List<Performer>>(
        future: dataStore.getJamNightRegularsNotInCurrentJam(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Performer>> snapshot) {
          if (snapshot.hasData) {
            return DropdownButton<Performer>(
              hint: const Text('Regulars'),
              value: savedPerformer,
              onChanged: (Performer? newValue) {
                onPerformerSelected(newValue!);
              },
              items: snapshot.data!.map((Performer performer) {
                return DropdownMenuItem<Performer>(
                  value: performer,
                  child: Text(performer.name),
                );
              }).toList(),
            );
          } else {
            return DropdownButton<Performer>(
                items: const [DropdownMenuItem(child: Text('Loading...'))],
                onChanged: null);
          }
        });
  }
}
