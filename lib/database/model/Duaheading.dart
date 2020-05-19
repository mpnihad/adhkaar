import 'package:adhkaar/database/model/Dua.dart';
import 'package:adhkaar/database/model/Section.dart';
import 'package:flutter/material.dart';

final String tableDuaHeading = 'tbl_dua';
final String columnDuaHeadingId = 'id';
final String columnDuaHeadingName = 'dua_name';
final String columnDuaHeadingRelatedId = 'dua_related_id';

class DuaHeading {
  //relation id
  int id;
  //dua id
  int duaId;
  int partno;
  String name;
  String duaAr;
  String duaTr;
  String image;
  String color;
  Color pallet;

  DuaHeading.forSearch(relatedId, String name, Color pallet){
    this.id=relatedId;
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
  DuaHeading.fromMaps(Map<String, dynamic> map) {
    id = map[columnDuaHeadingRelatedId];
    duaId = map[columnDuaId];
    name = map[columnDuaHeadingName];
    duaTr = map[columnDuaTr];
    duaAr = map[columnDuaAr];
    image = map[columnSecImage];
    color = map[columnSecColor];
    partno = map[columnDuaPartNo];
  }
}
