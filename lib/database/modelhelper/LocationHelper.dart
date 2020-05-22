import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Location.dart';
import 'package:adhkaar/database/model/Section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';

class LocationHelper extends ChangeNotifier{

  Future<Database> db;
  LocationHelper.forProvider();



  Future<Location> getLocation(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableLocation,
        columns: [columnCityName, columnLatitude, columnLongitude, columnUtcOffset,columnAltitude,columnTimezone,columnCountryCode],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Location.fromMap(maps.first);
    }
    return null;
  }




  Future<List> getAllLocations() async {
    List<Location> location = List();
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableLocation,
        columns: [columnCityName, columnLatitude, columnLongitude, columnUtcOffset,columnAltitude,columnTimezone,columnCountryCode],
      limit: 10
    );

    if (maps.length > 0) {
      maps.forEach((f) {
        location.add(Location.fromMap(f));
//          print("getAllLocations"+ Location.fromMap(f).toString());
      });
    }
    return location;
  }

  Future<int> getCount(int id) async {
    List<Location> location = List();
    var dbClient = await db;
    int count=1;
    List<Map> maps = await dbClient.rawQuery("SELECT COUNT(*) as count FROM $tableLocation where $columnParentId=$id;"
    );

    print("SELECT COUNT(*) as count FROM $tableLocation where $columnParentId=$id;");
    if (maps.length > 0) {
      maps.forEach((f) {
        Map<String, dynamic> countMap = Map.of(f);
        count = countMap['count'];
      });

    }
    return count;
  }


  LocationHelper(Future<Database> db)
  {
    this.db=db;
  }



  Future<List<Location>> searchLocaiton({String query}) async {

    try {

      var dbClient = await db;
      List<Location> duaHeadings = List();
      List<Map> maps = await dbClient.rawQuery("select * from $tableLocation  WHERE $columnCityName LIKE '$query%'  LIMIT 50");
      print("SQL QUERY:   select * from $tableLocation  WHERE $columnCityName LIKE '$query%'  LIMIT 50 ");
      print("SEARCH COMPLETED : $query");
      if (maps.length > 0) {
        maps.forEach((f) {
          duaHeadings.add(Location.fromMap(f));
//          print("getAllDuaHeadings"+ DuaHeading.fromMap(f).toString());
        });

      }
      print(duaHeadings.length);
      notifyListeners();
      return duaHeadings;


    } catch (err) {

      notifyListeners();
      return [];
    }
  }





}