import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class UserDatabaseHelper {
  //a helper class to drive the database
  static final _databaseName = "userDatabase.db";

  static final _databaseVersion = 1;

  UserDatabaseHelper._privateConstructor();

  static final UserDatabaseHelper instance = UserDatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    //get the database object
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // initialize the database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }


  Future _onCreate(Database db, int version) async {
    //create a new table object in the database
    return db.execute(
      "CREATE TABLE user(id INTEGER PRIMARY KEY, userId TEXT, nameF TEXT,nameL TEXT,email TEXT,contactId TEXT,OFYContactId TEXT,userType TEXT,ContactType TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertUser(User user) async {
    //add a user to the database
    final Database db = await database;

    int id = await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteUser(int id) async {
    // delete a user in the database
    final db = await database;

    await db.delete(
      'user',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<User>> queryUser() async {
    // Get a user from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('user');

    return List.generate(maps.length, (i) {
      return User(
        maps[i]['userId'],
        maps[i]['nameF'],
        maps[i]['nameL'],
        maps[i]['email'],
        maps[i]['contactId'],
        maps[i]['OFYContactId'],
        maps[i]['userType'],
        maps[i]['contactType'],
      );
    });
  }

}