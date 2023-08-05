import 'dart:async';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/instrument/instrument.dart';
import '../model/performer/performer.dart';

class JamNightDAO {
  static const _databaseName = "jam_night.db";
  static const _databaseVersion = 1;

  static const _performerTable = 'performer';

  static const _performerId = 'id';
  static const _performerName = 'name';
  static const _performerInstrument = 'instrument';
  static const _performerExperienceLevel = 'experience_level';

  // Singleton class
  JamNightDAO._privateConstructor();
  static final JamNightDAO instance = JamNightDAO._privateConstructor();

  // Database refeerence
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    // Lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_performerTable (
        $_performerId INTEGER PRIMARY KEY,
        $_performerName TEXT NOT NULL,
        $_performerInstrument TEXT NOT NULL,
        $_performerExperienceLevel TEXT NOT NULL
      )
      ''');
  }

  Future<void> insertPerformer(Performer performer) async {
    Database? db = await instance.database;
    await db!.insert(_performerTable, performer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Performer>> getPerformers() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> performers = await db!.query(_performerTable);
    return List.generate(performers.length, (i) {
      return Performer(
        name: performers[i][_performerName],
        instrument: _parseInstrument(performers[i][_performerInstrument]),
        experienceLevel:
            _parseExperienceLevel(performers[i][_performerExperienceLevel]),
        created: DateTime.now(),
      );
    });
  }

  Instrument _parseInstrument(String value) {
    return Instrument.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => throw ArgumentError(
          'Invalid instrument: $value'), // Return null or throw an exception if not found
    );
  }

  ExperienceLevel _parseExperienceLevel(String value) {
    return ExperienceLevel.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => throw ArgumentError(
          'Invalid experience level: $value'), // Return null or throw an exception if not found
    );
  }
}
