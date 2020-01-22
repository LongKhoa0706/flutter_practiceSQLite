import 'dart:async';
import 'dart:async';

import 'package:flutter_app1/model/person.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbManager {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      String path = join(await getDatabasesPath(), "person.db");
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: initDb,
      );
    }
  }

  void initDb(Database db, int version) async {
    return await db
        .execute("CREATE TABLE person (id INTEGER PRIMARY KEY AUTOINCREMENT,"
            " name TEXT , "
            "password TEXT ) ");
  }

  Future<int> insertPerson(Person person) async {
    await openDb();
    return await _database.insert('person', person.toMap());
  }

  Future<List<Person>> getPersonList() async {
    await openDb();
    var reponse = await _database.query('person');
    List<Person> arrPerson = reponse.map((f) => Person.fromMap(f)).toList();
    return arrPerson;
  }
  Future<int> deletePerson(int id ) async {
    await openDb();
    return await _database.delete('person',where: "id = ? ",whereArgs: [id]);
  }
  Future<int> updatePerson(Person person) async {
    await openDb();
    return await _database.update('person', person.toMap(),where: "id = ? ",whereArgs: [person.id]);
  }

  Future close() async {
    if (_database != null) {
      await _database.close();
      _database = null;
    }
  }
}
