import 'dart:async';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/instrument/instrument.dart';
import '../model/performer/performer.dart';
import '../model/performer/performerstatus.dart';

class JamNightDAO {
  static const _databaseName = "jam_night.db";
  static const _databaseVersion = 1;

  static const _performerTable = 'performer';

  static const _performerId = 'id';
  static const performerName = 'name';
  static const performerInstrument = 'instrument';
  static const performerExperienceLevel = 'experience_level';
  static const performerCreated = 'created';
  static const performerStatus = 'status';
  static const performerIsJamRegular = 'is_jam_regular';
  static const performerLastPlayed = 'last_played';
  static const performerNumberOfTimesPlayed = 'number_of_times_played';

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
        $performerName TEXT NOT NULL,
        $performerInstrument TEXT NOT NULL,
        $performerExperienceLevel TEXT NOT NULL,
        $performerCreated INTEGER NOT NULL,
        $performerStatus TEXT NOT NULL,
        $performerIsJamRegular INTEGER NOT NULL,
        $performerLastPlayed INTEGER NOT NULL,
        $performerNumberOfTimesPlayed INTEGER NOT NULL
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
        name: performers[i][performerName],
        instrument: _parseInstrument(performers[i][performerInstrument]),
        experienceLevel:
            _parseExperienceLevel(performers[i][performerExperienceLevel]),
        created: _parseDateTime(performers[i][performerCreated]),
        status: _parseStatus(performers[i][performerStatus]),
        isJamRegular: _parseBool(performers[i][performerIsJamRegular]),
        lastPlayed: _parseDateTime(performers[i][performerLastPlayed]),
        numberOfTimesPlayed: performers[i][performerNumberOfTimesPlayed],
      );
    });
  }

  Future<List<Performer>> getJamNightRegularsNotInCurrentJam() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> performers = await db!.query(
      _performerTable,
      where: '$performerStatus = ? AND $performerIsJamRegular = ?',
      whereArgs: [PerformerStatus.away.name, 1],
    );
    return List.generate(performers.length, (i) {
      return Performer(
        name: performers[i][performerName],
        instrument: _parseInstrument(performers[i][performerInstrument]),
        experienceLevel:
            _parseExperienceLevel(performers[i][performerExperienceLevel]),
        created: _parseDateTime(performers[i][performerCreated]),
        status: _parseStatus(performers[i][performerStatus]),
        isJamRegular: _parseBool(performers[i][performerIsJamRegular]),
        lastPlayed: _parseDateTime(performers[i][performerLastPlayed]),
        numberOfTimesPlayed: performers[i][performerNumberOfTimesPlayed],
      );
    });
  }

  // Update performer
  Future<void> updatePerformer(Performer performer) async {
    Database? db = await instance.database;
    await db!.update(
      _performerTable,
      performer.toMap(),
      where: '$performerName = ?',
      whereArgs: [performer.name],
    );
  }

  // Delete performer
  Future<void> deletePerformer(String name) async {
    Database? db = await instance.database;
    await db!.delete(
      _performerTable,
      where: '$performerName = ?',
      whereArgs: [name],
    );
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

  bool _parseBool(int value) {
    return value == 1;
  }

  DateTime _parseDateTime(int value) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  PerformerStatus _parseStatus(String value) {
    return PerformerStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => throw ArgumentError(
          'Invalid status: $value'), // Return null or throw an exception if not found
    );
  }
}
