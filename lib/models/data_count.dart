import 'package:cloud_firestore/cloud_firestore.dart';

class DataCount{
  static const ID_USER = 'uid';
  static const STEP = 'step';
  static const DISTANCE = 'distance';
  static const CALORIES = 'calories';
  static const TIME = 'time';
  static const DATE = 'date';

  String uid;
  String step;
  String distance;
  String calories;
  String time;
  String date;

  DataCount.formSnapShot(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    uid = data[ID_USER];
    step = data[STEP];
    distance = data[DISTANCE];
    time = data[TIME];
    calories = data[CALORIES];
    date = data[DATE];
  }

}