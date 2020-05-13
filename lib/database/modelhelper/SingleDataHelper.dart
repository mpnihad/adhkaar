
import 'package:adhkaar/database/model/SingleData.dart';
import 'package:sqflite/sqlite_api.dart';

class SingleDataHelper {

  Future<Database> db;


  Future<SingleData> insert(SingleData section) async {
    var dbClient = await db;
    section.id = await dbClient.insert(tableSingleData, section.toMap());
    return section;
  }

  Future<List<SingleData>> getSingleDatas(int id) async {
    var dbClient = await db;
    List<SingleData> singleDatas = List();
    List<Map> maps = await dbClient.rawQuery("select $columnSingleDataRelatedId,$columnSingleDataName from $tableSingleData where $columnSingleDataSecId=$id GROUP BY $columnSingleDataRelatedId");
    print("SQL QUERY:   select $columnSingleDataRelatedId as id,$columnSingleDataName from $tableSingleData where $columnSingleDataSecId=$id GROUP BY $columnSingleDataRelatedId");
    if (maps.length > 0) {
      maps.forEach((f) {
        singleDatas.add(SingleData.fromMap(f));

      });

    }
    return singleDatas;
  }









  SingleDataHelper(Future<Database> db)
  {
    this.db=db;
  }


}