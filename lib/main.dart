import 'package:flutter/material.dart';
import 'package:jamnight/data/jamnightdao.dart';
import 'package:provider/provider.dart';

import 'data/datastore.dart';
import 'jamnight.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => DataStore(JamNightDAO.instance),
    child: const JamNight(title: 'Jam Night'),
  ));
}
