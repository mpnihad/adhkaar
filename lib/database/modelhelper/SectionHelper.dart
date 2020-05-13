import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Section.dart';
import 'package:sqflite/sqlite_api.dart';

class SectionHelper {

  Future<Database> db;


  Future<Section> insert(Section section) async {
    var dbClient = await db;
    section.id = await dbClient.insert(tableSection, section.toMap());
    return section;
  }

  Future<Section> getSection(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableSection,
        columns: [columnId, columnName, columnTag, columnParentId,columnSecColor,columnSecImage],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Section.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
        tableSection, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Section section) async {
    var dbClient = await db;
    return await dbClient.update(tableSection, section.toMap(),
        where: '$columnId = ?', whereArgs: [section.id]);
  }

  Future<List> getAllSections() async {
    List<Section> section = List();
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableSection,
      columns: [columnId, columnName, columnTag, columnParentId,columnSecColor,columnSecImage],
        where: '$columnParentId is null or $columnParentId=?', whereArgs: ['']
    );

    if (maps.length > 0) {
      maps.forEach((f) {
        section.add(Section.fromMap(f));
//          print("getAllSections"+ Section.fromMap(f).toString());
      });
    }
    return section;
  }

  Future<int> getCount(int id) async {
    List<Section> section = List();
    var dbClient = await db;
    int count=1;
    List<Map> maps = await dbClient.rawQuery("SELECT COUNT(*) as count FROM $tableSection where $columnParentId=$id;"
    );

    print("SELECT COUNT(*) as count FROM $tableSection where $columnParentId=$id;");
    if (maps.length > 0) {
      maps.forEach((f) {
        Map<String, dynamic> countMap = Map.of(f);
        count = countMap['count'];
      });

    }
    return count;
  }
  Future<List> getAllSubSections(int secId) async {
    List<Section> section = List();
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableSection,
      columns: [columnId, columnName, columnTag, columnParentId,columnSecColor,columnSecImage],
        where: ' $columnParentId=?', whereArgs: [secId]
    );

    if (maps.length > 0) {
      maps.forEach((f) {
        section.add(Section.fromMap(f));
//          print("getAllSections"+ Section.fromMap(f).toString());
      });
    }
    return section;
  }

  SectionHelper(Future<Database> db)
  {
    this.db=db;
  }


}