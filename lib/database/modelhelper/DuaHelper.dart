import 'dart:ui';

import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Dua.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/model/Section.dart';
import 'package:sqflite/sqlite_api.dart';

class DuaHelper {

  Future<Database> db;



  Future<List<Dua>> getAllDua(int id) async {
    var dbClient = await db;
    List<Dua> duas = List();
    List<Map> maps = await dbClient.rawQuery("select * from $tableDua where $columnDuaRelatedId=$id");

    print("SQL QUERY: select * from $tableDua where $columnDuaRelatedId=$id");
    if (maps.length > 0) {
      maps.forEach((f) {
        duas.add(Dua.fromMap(f));
//          print("getAllDuas"+ Dua.fromMap(f).toString());
      });

    }
    return duas;
  }

  Future<int> updateCount(int id,int count) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("update $tableDua  SET $columnDuaTodaysCount =$count where $columnDuaId=$id");
    if (maps.length > 0) {
     return 1;
    }
    else return 0;
//    return await dbClient.update(tableSection, dua.toMap(),
//        where: '$columnId = ?', whereArgs: [dua.id]);
  }

  Future<List> getAllDuas() async {
    List<Dua> dua = List();
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableDua,
      columns: [columnId, columnName, columnTag, columnParentId,columnSecColor,columnSecImage],
        where: '$columnParentId is null or $columnParentId=?', whereArgs: ['']
    );

    if (maps.length > 0) {
      maps.forEach((f) {
        dua.add(Dua.fromMap(f));
//          print("getAllDuas"+ Dua.fromMap(f).toString());
      });
    }
    return dua;
  }


  DuaHelper(Future<Database> db)
  {
    this.db=db;
  }


}