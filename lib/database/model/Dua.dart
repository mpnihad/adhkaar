
import 'package:flutter/material.dart';

final String tableDua = 'tbl_dua';
final String columnDuaId = 'id';
final String columnDuaIds = 'ids';
final String columnDuaName = 'dua_name';
final String columnDuaRelatedId= 'dua_related_id';
final String columnDuaAr= 'dua_ar';
final String columnDuaAr2= 'dua_ar_2';
final String columnDuaAudAr= 'dua_aud_ar';
final String columnDuaAudArStart= 'dua_aud_ar_stat';
final String columnDuaAudMl= 'dua_aud_ml';
final String columnDuaAudMlStart= 'dua_aud_ml_stat';
final String columnDuaFav= 'dua_fav';
final String columnDuaFl= 'dua_fl';
final String columnDuaFooter= 'dua_footer';
final String columnDuaHeader= 'dua_header';
final String columnDuaHmNo= 'dua_hm_no';
final String columnDuaMiddle= 'dua_middle';
final String columnDuaOth= 'dua_oth';
final String columnDuaPartNo= 'dua_part_no';
final String columnDuaTr= 'dua_tr';
final String columnDuaTr2= 'dua_tr_2';
final String columnDuaTrans= 'dua_trans';
final String columnDuaTrans2= 'dua_trans_2';
final String columnDuaSecId= 'sec_id';
final String columnDuaTodaysCount= 'todays_count';
final String columnDuaTotalCount= 'total_count';



class Dua {
  String duaAr;
  String duaAr2;
  String duaAudAr;
  String duaAudArStat;
  String duaAudMl;
  String duaAudMlStat;
  String duaFav;
  String duaFl;
  String duaFooter;
  String duaHeader;
  int duaHmNo;
  String duaMiddle;
  String duaName;
  String duaOth;
  int duaPartNo;
  int duaRelatedId;
  String duaTr;
  String duaTr2;
  String duaTrans;
  String duaTrans2;
  int id;
  int secId;
  int todaysCount;
  int totalCount;
  int playStatus=0;

  Dua(
      {this.duaAr,
        this.duaAr2,
        this.duaAudAr,
        this.duaAudArStat,
        this.duaAudMl,
        this.duaAudMlStat,
        this.duaFav,
        this.duaFl,
        this.duaFooter,
        this.duaHeader,
        this.duaHmNo,
        this.duaMiddle,
        this.duaName,
        this.duaOth,
        this.duaPartNo,
        this.duaRelatedId,
        this.duaTr,
        this.duaTr2,
        this.duaTrans,
        this.duaTrans2,
        this.id,
        this.secId,
        this.todaysCount,
        this.totalCount,
      this.playStatus=0});

  Dua.fromMap(Map<String, dynamic> map) {
    duaAr = map[columnDuaAr];
    duaAr2 = map[columnDuaAr2];
    duaAudAr = map[columnDuaAudAr];
    duaAudArStat = map[columnDuaAudArStart];
    duaAudMl = map[columnDuaAudMl];
    duaAudMlStat = map[columnDuaAudMlStart];
    duaFav = map[columnDuaFav];
    duaFl = map[columnDuaFl];
    duaFooter = map[columnDuaFooter];
    duaHeader = map[columnDuaHeader];
    duaHmNo = map[columnDuaHmNo];
    duaMiddle = map[columnDuaMiddle];
    duaName = map[columnDuaName];
    duaOth = map[columnDuaOth];
    duaPartNo = map[columnDuaPartNo];
    duaRelatedId = map[columnDuaRelatedId];
    duaTr = map[columnDuaTr];
    duaTr2 = map[columnDuaTr2];
    duaTrans = map[columnDuaTrans];
    duaTrans2 = map[columnDuaTrans2];
    id = map[columnDuaId];
    secId = map[columnDuaSecId];
    todaysCount = map[columnDuaTodaysCount];
    totalCount = map[columnDuaTotalCount];
  }

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{
    columnDuaAr: this.duaAr,
    columnDuaAr2: this.duaAr2,
    columnDuaAudAr: this.duaAudAr,
    columnDuaAudArStart: this.duaAudArStat,
    columnDuaAudMl: this.duaAudMl,
    columnDuaAudMlStart: this.duaAudMlStat,
    columnDuaFav: this.duaFav,
    columnDuaFl: this.duaFl,
    columnDuaFooter: this.duaFooter,
    columnDuaHeader: this.duaHeader,
    columnDuaHmNo: this.duaHmNo,
    columnDuaMiddle: this.duaMiddle,
    columnDuaName: this.duaName,
    columnDuaOth: this.duaOth,
    columnDuaPartNo: this.duaPartNo,
    columnDuaRelatedId: this.duaRelatedId,
    columnDuaTr: this.duaTr,
    columnDuaTr2: this.duaTr2,
    columnDuaTrans: this.duaTrans,
    columnDuaTrans2: this.duaTrans2,
    columnDuaId: this.id,
    columnDuaSecId: this.secId,
    columnDuaTodaysCount: this.todaysCount,
    columnDuaTotalCount: this.totalCount
    };
    return data;
  }
}