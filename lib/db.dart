import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'person.dart';

class AppDB {
  AppDB._();
  static final AppDB instance = AppDB._();

  Future<Database> _openDB() async {
    final dbPath = join(await getDatabasesPath(), 'person.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE person(name TEXT, faceJpg BLOB, templates BLOB)',
        );
      },
    );
  }

  Future<List<Person>> loadAllPersons() async {
    final db = await _openDB();
    final maps = await db.query('person');
    return maps.map((e) => Person.fromMap(e)).toList();
  }
}
