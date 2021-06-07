import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/note.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "notesDatabase.db";

  static final _databaseVersion = 1;

  NotesDatabaseHelper._privateConstructor();

  static final NotesDatabaseHelper instance =
      NotesDatabaseHelper._privateConstructor();
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
      "CREATE TABLE notes(id TEXT,boatId TEXT,destination TEXT,startDate TEXT,endDate TEXT,preTripNotes TEXT,postTripNotes TEXT,miscNotes TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertNotes(Note note) async {
    //add a notes to the database
    final Database db = await database;

    int id = await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteNotes(String id) async {
    // delete a notes in the database
    final db = await database;

    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteNotesTable() async {
    //delete the entire notes table in the database
    final db = await database;
    await db.delete('notes');
  }

  Future<bool> notesExists(String notesId) async {
    //check if a notes exists based on its notes id
    final db = await database;
    var result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM notes WHERE id = ?)', [notesId]);
    int exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<Note> getNotes(String notesId) async {
    //get a notes from the database based on its notesId
    final db = await database;
    var result =
        await db.rawQuery('SELECT * FROM notes WHERE id = ?', [notesId]);
    return Note(
      result[0]['id'],
      result[0]['boatId'],
      result[0]['destination'],
      result[0]['startDate'],
      result[0]['endDate'],
      result[0]['preTripNotes'],
      result[0]['postTripNotes'],
      result[0]['miscNotes'],
        null,
        null,
        null,
    );
  }

  Future<List<Note>> queryNotes() async {
    // Get the entire notes table from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Note(
        maps[i]['id'],
        maps[i]['boatId'],
        maps[i]['destination'],
        maps[i]['startDate'],
        maps[i]['endDate'],
        maps[i]['preTripNotes'],
        maps[i]['postTripNotes'],
        maps[i]['miscNotes'],
        null,
        null,
        null,
      );
    });
  }
  //TODO note there must be a callback, context, and user set on pull from database
}
