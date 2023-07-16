import 'package:flutter/material.dart';

import '../../model/instrument/instrument.dart';

class InstrumentDropdown extends StatefulWidget {
  const InstrumentDropdown({super.key, required this.onInstrumentSelected});

  final ValueChanged<Instrument> onInstrumentSelected;

  @override
  State<InstrumentDropdown> createState() => _InstrumentDropdownState();
}

class _InstrumentDropdownState extends State<InstrumentDropdown> {
  Instrument? _selectedInstrument;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Instrument>(
      hint: const Text('Select Instrument'),
      value: _selectedInstrument,
      onChanged: (Instrument? newValue) {
        setState(() {
          _selectedInstrument = newValue;
          widget.onInstrumentSelected(newValue!);
        });
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