import 'package:aduan/config/config.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = await getDatabasesPath() + Config().getDbName;
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
          CREATE TABLE ${Config().getTable} (
            ${Config().getColumnId} INTEGER PRIMARY KEY,
            ${Config().getColumnKey} TEXT NOT NULL,
            ${Config().getColumnValue} TEXT NOT NULL
          )
      ''',
    );
  }

  Future insertData(String key, String value) async {
    Database db = await instance.database;
    await db.insert(
      Config().getTable,
      {
        Config().getColumnKey: key,
        Config().getColumnValue: value,
      },
    );
  }

  Future updateData(String key, String value) async {
    Database db = await instance.database;
    await db.update(
      Config().getTable,
      {
        Config().getColumnValue: value,
      },
      where: '${Config().getColumnKey} = ?',
      whereArgs: [key],
    );
  }

  Future deleteData(String key) async {
    Database db = await instance.database;
    await db.delete(
      Config().getTable,
      where: '${Config().getColumnKey} = ?',
      whereArgs: [key],
    );
  }

  Future<List> getData() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(Config().getTable);
    return List.generate(maps.length, (i) {
      return {
        Config().getColumnId: maps[i][Config().getColumnId],
        Config().getColumnKey: maps[i][Config().getColumnKey],
        Config().getColumnValue: maps[i][Config().getColumnValue],
      };
    });
  }

  // Future<List<Map<String, dynamic>>> getData() async {
  //   Database db = await instance.database;
  //   return await db.query(Config().getTable);
  // }

  Future<String> getDataByKey(String key) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data = await db.query(
      Config().getTable,
      where: '${Config().getColumnKey} = ?',
      whereArgs: [key],
    );

    if (data.isNotEmpty) {
      return data[0][Config().getColumnValue];
    } else {
      return '';
    }
  }

  // find key
  Future<bool> findKey(String key) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data = await db.query(
      Config().getTable,
      where: '${Config().getColumnKey} = ?',
      whereArgs: [key],
    );
    return data.isNotEmpty;
  }

  // delete all data
  Future deleteAll() async {
    Database db = await instance.database;
    await db.delete(Config().getTable);
  }

  Future close() async {
    Database db = await instance.database;
    db.close();
  }
}
