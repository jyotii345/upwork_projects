import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "userDatabase.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }




  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    return db.execute(
      "CREATE TABLE user(id INTEGER PRIMARY KEY, userId TEXT, nameF TEXT,nameL TEXT,email TEXT,contactId TEXT,OFYContactId TEXT,userType TEXT,ContactType TEXT)",
    );
  }

  // Database helper methods:

  Future<int> insertUser(User user) async {
    final Database db = await database;

    int id = await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteUser(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the Database.
    await db.delete(
      'user',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<User>> queryUser() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The users.
    final List<Map<String, dynamic>> maps = await db.query('user');

    // Convert the List<Map<String, dynamic> into a List<NewUser>.
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

// TODO: queryAllWords()
// TODO: update(Word word)
}