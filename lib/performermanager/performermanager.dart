import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/performer/performer.dart';
import 'addperformerbutton.dart';
import 'enternamebox.dart';
import 'instrumentdropdown.dart';
import 'performerlist.dart';
import 'performermanagermodel.dart';
import 'searchperformertextbox.dart';
import 'selectregulardropdown.dart';

class PerformerManager extends StatelessWidget {
  PerformerManager({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchPerformerController =
      TextEditingController();

  void _addPerformerToCurrentJam(PerformerManagerModel performerManagerModel) {
    performerManagerModel.addPerformerToCurrentJam();
    _nameController.clear();
  }

  void _selectSavedPerformer(
      PerformerManagerModel performerManagerModel, Performer performer) {
    performerManagerModel.selectSavedPerformer(performer);
    _nameController.text = performer.name;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PerformerManagerModel>(
      builder: (context, performerManagerModel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Performer Manager'),
          ),
          body: ListView(
            children: <Widget>[
              SelectRegularDropdown(
                  savedPerformer: performerManagerModel.savedPerformer,
                  onPerformerSelected: (Performer performer) =>
                      _selectSavedPerformer(performerManagerModel, performer)),
              EnterNameBox(
                  key: EnterNameBox.widgetKey,
                  nameController: _nameController,
                  onChanged: performerManagerModel.onNameChanged),
              InstrumentDropdown(
                  instrument: performerManagerModel.instrument,
                  onInstrumentSelected: performerManagerModel.selectInstrument),
              AddPerformerButton(
                  onAddPerformerPressed: () =>
                      _addPerformerToCurrentJam(performerManagerModel)),
              SearchPerformerTextBox(
                  searchPerformerController: _searchPerformerController,
                  onChanged: performerManagerModel.onSearchPerformerChanged),
              PerformerList(
                  performers: performerManagerModel.filteredPerformerList,
                  onRemoved:
                      performerManagerModel.removePerformerFromCurrentJam,
                  onSaved: performerManagerModel.savePerformerAsRegular),
            ],
          ),
        );
      },
    );
  }
}
