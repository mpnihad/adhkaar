
import 'package:flutter/material.dart';

final String tableSingleData = 'tbl_dua';
final String columnSingleDataId = 'id';
final String columnSingleDataName = 'dua_name';
final String columnSingleDataRelatedId= 'dua_related_id';

final String columnSingleDataSecId= 'sec_id';

class SingleData {
  int id;
  String name;
  int relatedId;
  Color pallet;


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSingleDataId: id,
      columnSingleDataName: name,
      columnSingleDataRelatedId: relatedId,

    };
    if (id != null) {
      map[columnSingleDataId] = id;
    }
    return map;
  }

  SingleData();

  SingleData.fromMap(Map<String, dynamic> map) {
    id = map[columnSingleDataId];
    name = map[columnSingleDataName];
    relatedId = map[columnSingleDataRelatedId];


  }
}