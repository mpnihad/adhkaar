import 'dart:ui';

import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Dua.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/model/Section.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class DuaHeadingHelper extends ChangeNotifier{

  Future<Database> db;


  DuaHeadingHelper.forProvider();

  Future<List<DuaHeading>> getAllDuaHeading(int id) async {
    var dbClient = await db;
    List<DuaHeading> duaHeadings = List();
    List<Map> maps = await dbClient.rawQuery("select $columnDuaHeadingRelatedId,$columnDuaHeadingName from $tableDuaHeading where $columnDuaSecId=$id GROUP BY $columnDuaHeadingRelatedId");
print("SQL QUERY:   select $columnDuaHeadingRelatedId as id,$columnDuaHeadingName from $tableDuaHeading where $columnDuaSecId=$id GROUP BY $columnDuaHeadingRelatedId");
    if (maps.length > 0) {
      maps.forEach((f) {
        duaHeadings.add(DuaHeading.fromMap(f));
//          print("getAllDuaHeadings"+ DuaHeading.fromMap(f).toString());
      });

    }
    return duaHeadings;
  }



  Future<List> getAllDuaHeadings() async {
    List<DuaHeading> duaHeading = List();
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableDuaHeading,
      columns: [columnId, columnName, columnTag, columnParentId,columnSecColor,columnSecImage],
        where: '$columnParentId is null or $columnParentId=?', whereArgs: ['']
    );

    if (maps.length > 0) {
      maps.forEach((f) {
        duaHeading.add(DuaHeading.fromMap(f));
//          print("getAllDuaHeadings"+ DuaHeading.fromMap(f).toString());
      });
    }
    return duaHeading;
  }


  DuaHeadingHelper(Future<Database> db)
  {
    this.db=db;
  }

  Future<List<DuaHeading>> searchProducts({String query}) async {

    try {

      var dbClient = await db;
      List<DuaHeading> duaHeadings = List();
      List<Map> maps = await dbClient.rawQuery("select $columnDuaHeadingRelatedId,$columnDuaHeadingName from $tableDuaHeading  WHERE $columnDuaName LIKE '%$query%' OR $columnDuaTr LIKE '%$query%' OR $columnDuaTrans LIKE '%$query%' GROUP BY $columnDuaHeadingRelatedId");
      print("SQL QUERY:   select $columnDuaHeadingRelatedId,$columnDuaHeadingName from $tableDuaHeading  WHERE $columnDuaName LIKE '%$query%' OR $columnDuaTr LIKE '%$query%' OR $columnDuaTrans LIKE '%$query%' GROUP BY $columnDuaHeadingRelatedId");
      if (maps.length > 0) {
        maps.forEach((f) {
          duaHeadings.add(DuaHeading.fromMap(f));
//          print("getAllDuaHeadings"+ DuaHeading.fromMap(f).toString());
        });

      }
      notifyListeners();
      return duaHeadings;


    } catch (err) {

      notifyListeners();
      return [];
    }
  }
}