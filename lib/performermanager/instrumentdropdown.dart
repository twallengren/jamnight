import 'package:flutter/material.dart';

import '../../model/instrument/instrument.dart';

class InstrumentDropdown extends StatelessWidget {
  const InstrumentDropdown(
      {super.key,
      required this.instrument,
      required this.onInstrumentSelected});

  final Instrument? instrument;
  final ValueChanged<Instrument> onInstrumentSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Instrument>(
      hint: const Text('Select Instrument'),
      value: instrument,
      onChanged: (Instrument? newValue) {
        onInstrumentSelected(newValue!);
      },
      items: Instrument.values.map((Instrument instrument) {
        return DropdownMenuItem<Instrument>(
          value: instrument,
          child: Text(instrument.name.toUpperCase()),
        );
      }).toList(),
    );
  }
}
