import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ManageDatabase {
  Map<int, String> migrationScripts = {
    1: '''CREATE TABLE users(id TEXT PRIMARY KEY, firstName TEXT, lastName TEXT, fullName TEXT, email TEXT, phone TEXT, avatar TEXT, token TEXT, points TEXT, badge TEXT, username TEXT)
              ''',
  };

  Future<Database> initialise() async {
    int nbrMigrationScripts = migrationScripts.length;
// Open the database and store the reference.
    final database = openDatabase(
      join(await getDatabasesPath(), 'kap_database.db'),
      onCreate: (db, version) async {
        // Run the CREATE users TABLE statement on the database.
        await db.execute(
          'CREATE TABLE users(id TEXT PRIMARY KEY, firstName TEXT, lastName TEXT, fullName TEXT, email TEXT, phone TEXT, avatar TEXT, token TEXT, points TEXT, badge TEXT, username TEXT)',
        );
        return;
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; i++) {
          await db.execute(migrationScripts[i]!);
        }
      },
      version: nbrMigrationScripts,
    );
    return database;
  }
}
