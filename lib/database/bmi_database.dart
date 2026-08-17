import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/bmi_measurement.dart';
import 'bmi_fields.dart';

class BmiDatabase {
  // ==========================================================
  // Singleton
  // ==========================================================

  BmiDatabase._init();

  static final BmiDatabase instance = BmiDatabase._init();

  static Database? _database;

  // ==========================================================
  // Database Getter
  // ==========================================================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('bmi.db');

    return _database!;
  }

  // ==========================================================
  // Initialize Database
  // ==========================================================

  Future<Database> _initDB(String databaseName) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, databaseName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // ==========================================================
  // Create Tables
  // ==========================================================

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    const intType = 'INTEGER NOT NULL';

    const realType = 'REAL NOT NULL';

    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE ${BmiFields.tableMeasurements} (
        ${BmiFields.id} $idType,
        ${BmiFields.gender} $textType,
        ${BmiFields.height} $intType,
        ${BmiFields.weight} $realType,
        ${BmiFields.age} $intType,
        ${BmiFields.bmi} $realType,
        ${BmiFields.bodyFat} $realType,
        ${BmiFields.bmr} $realType,
        ${BmiFields.dailyCalories} $intType,
        ${BmiFields.measuredAt} $textType
      )
    ''');
  }

  // ==========================================================
  // CREATE
  // ==========================================================

  Future<BmiMeasurement> createMeasurement(BmiMeasurement measurement) async {
    final db = await instance.database;

    final id = await db.insert(
      BmiFields.tableMeasurements,
      measurement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return measurement.copy(id: id);
  }

  // ==========================================================
  // READ ONE
  // ==========================================================

  Future<BmiMeasurement> readMeasurement(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      BmiFields.tableMeasurements,
      columns: BmiFields.values,
      where: '${BmiFields.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return BmiMeasurement.fromMap(maps.first);
    }

    throw Exception('Measurement with ID $id not found');
  }

  // ==========================================================
  // READ ALL
  // ==========================================================

  Future<List<BmiMeasurement>> readAllMeasurements() async {
    final db = await instance.database;

    final result = await db.query(
      BmiFields.tableMeasurements,
      columns: BmiFields.values,
      orderBy: '${BmiFields.measuredAt} DESC',
    );

    return result.map((json) => BmiMeasurement.fromMap(json)).toList();
  }

  // ==========================================================
  // READ LAST 30
  // ==========================================================

  Future<List<BmiMeasurement>> readLast30Measurements() async {
    final db = await instance.database;

    final result = await db.query(
      BmiFields.tableMeasurements,
      columns: BmiFields.values,
      orderBy: '${BmiFields.measuredAt} DESC',
      limit: 30,
    );

    return result
        .map((json) => BmiMeasurement.fromMap(json))
        .toList()
        .reversed
        .toList();
  }

  // ==========================================================
  // READ LATEST
  // ==========================================================

  Future<BmiMeasurement?> getLatestMeasurement() async {
    final db = await instance.database;

    final result = await db.query(
      BmiFields.tableMeasurements,
      columns: BmiFields.values,
      orderBy: '${BmiFields.measuredAt} DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return BmiMeasurement.fromMap(result.first);
  }

  // ==========================================================
  // READ PREVIOUS
  // ==========================================================

  Future<BmiMeasurement?> getPreviousMeasurement() async {
    final db = await instance.database;

    final result = await db.query(
      BmiFields.tableMeasurements,
      columns: BmiFields.values,
      orderBy: '${BmiFields.measuredAt} DESC',
      limit: 2,
    );

    if (result.length < 2) {
      return null;
    }

    return BmiMeasurement.fromMap(result[1]);
  }

  // ==========================================================
  // UPDATE
  // ==========================================================

  Future<int> updateMeasurement(BmiMeasurement measurement) async {
    if (measurement.id == null) {
      throw Exception('Cannot update measurement without ID');
    }

    final db = await instance.database;

    return db.update(
      BmiFields.tableMeasurements,
      measurement.toMap(),
      where: '${BmiFields.id} = ?',
      whereArgs: [measurement.id],
    );
  }

  // ==========================================================
  // DELETE ONE
  // ==========================================================

  Future<int> deleteMeasurement(int id) async {
    final db = await instance.database;

    return db.delete(
      BmiFields.tableMeasurements,
      where: '${BmiFields.id} = ?',
      whereArgs: [id],
    );
  }

  // ==========================================================
  // DELETE ALL
  // ==========================================================

  Future<int> deleteAllMeasurements() async {
    final db = await instance.database;

    return db.delete(BmiFields.tableMeasurements);
  }

  // ==========================================================
  // COUNT
  // ==========================================================

  Future<int> getMeasurementCount() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*)
      AS count
      FROM ${BmiFields.tableMeasurements}
      ''');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==========================================================
  // CLOSE
  // ==========================================================

  Future<void> close() async {
    final db = await instance.database;

    await db.close();

    _database = null;
  }
}
