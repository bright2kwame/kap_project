import 'package:knowledge_access_power/model/manage_database.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DBOperations {
  // Define a function that inserts dogs into the database
  Future<void> insertUser(UserItem user) async {
    // Get a reference to the database.
    final db = await ManageDatabase().initialise();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<UserItem>> users() async {
    // Get a reference to the database.
    final db = await ManageDatabase().initialise();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      var data = maps[i];
      return parseQueryData(data);
    });
  }

  UserItem parseQueryData(dynamic data) {
    return UserItem(
      id: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      fullName: data['fullName'],
      email: data['email'],
      phone: data['phone'],
      avatar: data['avatar'],
      token: data['token'],
      points: data['points'],
      username: data['username'],
    );
  }

  Future<void> updateUser(UserItem user) async {
    // Get a reference to the database.
    final db = await ManageDatabase().initialise();

    // Update the given user.
    await db.update(
      'users',
      user.toPartialMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  //MARK: get user
  Future<UserItem> getUser() async {
    final db = await ManageDatabase().initialise();
    var queryResult = await db.query('users', limit: 1);
    return parseQueryData(queryResult[0]);
  }

  Future<void> deleteUser(String id) async {
    // Get a reference to the database.
    final db = await ManageDatabase().initialise();

    // Remove the Dog from the database.
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the User's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
