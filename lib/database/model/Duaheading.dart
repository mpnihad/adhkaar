import 'package:flutter/material.dart';

final String tableDuaHeading = 'tbl_dua';
final String columnDuaHeadingId = 'id';
final String columnDuaHeadingName = 'dua_name';
final String columnDuaHeadingRelatedId = 'dua_related_id';

class DuaHeading {
  int id;
  String name;
  Color pallet;

  DuaHeading.forSearch(relatedId, String name, Color pallet){
    this.id=id;
    this.name=name;
    this.pallet=pallet;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDuaHeadingId: name,
    };
    if (id != null) {
      map[columnDuaHeadingId] = id;
    }
    return map;
  }

  DuaHeading();

  DuaHeading.forSingleData(int id, String name, Color pallet) {
    this.id=id;
    this.name=name;
    this.pallet=pallet;
  }

  DuaHeading.fromMap(Map<String, dynamic> map) {
    id = map[columnDuaHeadingRelatedId];
    name = map[columnDuaHeadingName];
  }
}
