import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:story_plus/story_model.dart';

class SqliteDatabase {
  SqliteDatabase._internal();

  static final _instance = SqliteDatabase._internal();

  factory SqliteDatabase() => _instance;

  final String _database = 'stories_plus';

  final String _table = 'stories',
      _column1 = 'title',
      _column2 = 'content',
      _column3 = 'image';

  Future<Database> _initDatabase() async {
    String devicesPath = await getDatabasesPath();
    String path = join(devicesPath, '$_database.db');

    return await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('CREATE TABLE $_table ($_column1 TEXT PRIMARY KEY NOT NULL, '
            '$_column2 TEXT NOT NULL, $_column3 BLOB)');
      },
      version: 1,
    );
  }

  Future<int> insertIntoDatabase(List<StoryModel> stories) async {
    final db = await _initDatabase();
    for (var s in stories) {
      db.insert(
        _table,
        s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    return stories.length;
  }

  Future<List<StoryModel>> getStories() async {
    final db = await _initDatabase();
    final data = await db.query(_table);
    return List.generate(
        data.length, (index) => StoryModel.fromMap(data[index]));
  }

  Future<int> saveImage(String image, Uint8List bytes) async {
    final db = await _initDatabase();
    return db.update(_table, {_column3: bytes},
        where: 'title = ?', whereArgs: [image]);
  }

  Future<Uint8List?> getImage(String image) async {
    final db = await _initDatabase();
    List<Map<String, dynamic>> result = await db.query(
      _table,
      where: '$_column1 = ?',
      whereArgs: [image],
      limit: 1,
    );
    return result.first.entries.elementAt(2).value;
  }

  Future deleteTable() async {
    String devicesPath = await getDatabasesPath();
    String path = join(devicesPath, '$_database.db');
    deleteDatabase(path);
  }
}
