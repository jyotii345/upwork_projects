import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ContactDatabaseHelper {
  // a helper class to drive the database
  //
  static final _databaseName = "contactDatabase.db";

  static final _databaseVersion = 1;

  ContactDatabaseHelper._privateConstructor();

  static final ContactDatabaseHelper instance =
      ContactDatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    // get the database object
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    // initialize the database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // create a new table object in the database
    return db.execute(
      "CREATE TABLE contact(id INTEGER PRIMARY KEY,contactid TEXT, firstname TEXT, middlename TEXT, lastname TEXT, email TEXT, vipcount TEXT, vippluscount TEXT, sevenseascount TEXT, aacount TEXT, boutiquepoints TEXT,vip TEXT, vipPlus TEXT, sevenSeas TEXT, adventuresClub TEXT, memberSince TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertContact(
      String contactId,
      String firstName,
      String middleName,
      String lastName,
      String email,
      String vipCount,
      String vipPlusCount,
      String sevenSeasCount,
      String aaCount,
      String boutiquePoints,
      String vip,
      String vipPlus,
      String sevenSeas,
      String adventuresClub,
      String memberSince) async {
    // add a contact to the database
    final Database db = await database;

    int id = await db.insert(
      'contact',
      {
        'contactid': contactId,
        'firstname': firstName,
        'middlename': middleName,
        'lastname': lastName,
        'email': email,
        'vipcount': vipCount,
        'vippluscount': vipPlusCount,
        'sevenseascount': sevenSeasCount,
        'aacount': aaCount,
        'boutiquepoints': boutiquePoints,
        'vip': vip,
        'vipPlus': vipPlus,
        'sevenSeas': sevenSeas,
        'adventuresClub': adventuresClub,
        'memberSince': memberSince,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteContact(int id) async {
    // delete a contact in the database
    final db = await database;

    await db.delete(
      'contact',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteContactTable() async {
    //delete the entire contact table in the database
    final db = await database;
    await db.delete('contact');
  }

  Future<bool> contactExists(String contactId) async {
    //check if a contact exists in the database by the contact path and name
    final db = await database;
    var result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM contact WHERE contactid = ?)',
        [contactId]);
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<Map<String, dynamic>>> queryContact() async {
    // Get a contact from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('contact');

    return List.generate(maps.length, (i) {
      return
        {'contactId': maps[i]['contactid'],
        'firstName' : maps[i]['firstname'],
        'middleName' : maps[i]['middlename'],
        'lastName' : maps[i]['lastname'],
        'email' : maps[i]['email'],
        'vipCount': maps[i]['vipcount'],
        'vipPlusCount' : maps[i]['vippluscount'],
        'sevenSeasCount' : maps[i]['sevenseascount'],
        'aaCount' : maps[i]['aacount'],
        'boutiquePoints' : maps[i]['boutiquepoints'],
        'vip' : maps[i]["vip"],
        'vipPlus' : maps[i]["vipPlus"],
        'sevenSeas' : maps[i]["sevenSeas"],
        'adventureSClub' : maps[i]["adventuresClub"],
        'memberSince' : maps[i]["memberSince"]};
    });
  }
}
