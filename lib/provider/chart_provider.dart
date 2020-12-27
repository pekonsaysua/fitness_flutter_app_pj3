
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/data_count.dart';
import 'package:fl_chart/fl_chart.dart';
class ChartProvider  with ChangeNotifier{
  Firestore _firestore = Firestore.instance;
  List<DataCount> _listData = [];

  List<DataCount> get listData => _listData;

  set listData(List<DataCount> value) {
    _listData = value;
  }

  List<String> listDate = [];
  List<FlSpot> listPoint = [];
  DataCount dataCount;

  Future<List<DataCount>> getDataCount(String uid) async {

    _firestore.collection('data_count')
    .where("uid", isEqualTo: uid)
    .snapshots()
    .listen((data) => data.documents.forEach((doc){
      dataCount = DataCount.formSnapShot(doc);
      _listData.add(dataCount);
      notifyListeners();
    }));
    print(_listData.length);
  }

//  double _x;
//  double _y;
//  Future<List<FlSpot>> getDate () async{
//    listData = await getDataCount();
//    for(int i = 0; i<= listData.length;i++){
//      String day = (listData[i].date.split(" "))[0];
//      //listDate.add((listData[i].date.split(" "))[0]);
//      _y = 7/(3000/double.parse(listData[i].step));
//      _y = num.parse(_y.toStringAsFixed(2));
//      switch(getDay(day)){
//        case 1:
//          _x = 0;break;
//        case 2:
//          _x = 2;break;
//        case 3:
//          _x = 4;break;
//        case 4:
//          _x = 6;break;
//        case 5:
//          _x = 7;break;
//        case 6:
//          _x = 10;break;
//        case 7:
//          _x = 12;break;
//      }
//      print(_y);
//      listPoint.add(FlSpot(_x, _y));
//    }
//    return listPoint;
//    //notifyListeners();
//  }
//  int getDay(String date){
//    int JMD;
//    int day;
//    int month;
//    int year;
//    List<String> list = [];
//    list = date.split("-");
//    year = int.parse(list[0]);
//    month = int.parse(list[1]);
//    day = int.parse(list[3]);
//
//    JMD = ((day + ((153 * (month + 12 * ((14 - month) / 12) - 3) + 2) / 5) +
//        (365 * (year + 4800 - ((14 - month) / 12))) +
//        ((year + 4800 - ((14 - month) / 12)) / 4) -
//        ((year + 4800 - ((14 - month) / 12)) / 100) +
//        ((year + 4800 - ((14 - month) / 12)) / 400)  - 32045) % 7).round();
//    print(JMD);
//    return JMD;
//
//  }
}
