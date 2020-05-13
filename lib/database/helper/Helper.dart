
import 'package:adhkaar/database/model/Section.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

class Helper {
  static final Helper _instance = new Helper.internal();
  factory Helper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "asset_adhkar.db");

// Only copy if the database doesn't exist
    if (io.FileSystemEntity.typeSync(path) == io.FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'adhkar.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new io.File(path).writeAsBytes(bytes);
    }
    io.Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'asset_adhkar.db');
    var theDb = await openDatabase(databasePath);

//    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, "main.db");
//    var theDb = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
//      await db.execute('''
//          create table $tableUser (
//          $columnId integer primary key autoincrement,
//          $columnName text not null,
//          $columnPhone text not null,
//          $columnEmail email not null)
//          ''');
//    });
    return theDb;
  }


  Helper.internal();



  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}