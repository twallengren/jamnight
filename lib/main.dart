import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'datastore.dart';
import 'jamnight.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => DataStore(),
    child: const JamNight(title: 'Jam Night'),
  ));
}
