import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/models/data_count.dart';
import 'package:fitness_app/models/user.dart';

class Api{
  static Future<UserData> getUserApi(String userId) async{
    UserData user;
    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((value) {
      user = UserData.fromJson(value.data);
    });
    return user;
  }

  static Future<DataCount> getActivityApi(String actId) async{
    DataCount act;
    await Firestore.instance
        .collection('activities')
        .document(actId)
        .get()
        .then((value) {
       act = DataCount.fromJson(value.data);
    });
    return act;
  }

}