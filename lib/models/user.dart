import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static const ID = 'uid';
  static const NAME = 'name';
  static const EMAIL = 'email';
  static const PHONE = 'phone';
  static const PASS = 'pass';
  static const HEIGHT = 'height';
  static const WEIGHT = 'weight';
  static const URL_AVT = 'url_avt';
  static const URL_COVER = 'url_cover';
  String id;
  String name;
  String email;
  String phone;
  String pass;
  String weight;
  String height;
  String urlAvt;
  String urlCover;

  UserData(this.id, this.name, this.email, this.phone, this.pass, this.weight,
      this.height, this.urlAvt, this.urlCover);

  UserData.compact(this.id, this.name, this.urlAvt);

  UserData.formSnapShot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    id = data[ID];
    name = data[NAME];
    email = data[EMAIL];
    phone = data[PHONE];
    weight = data[WEIGHT];
    height = data[HEIGHT];
    urlAvt = data[URL_AVT];
    urlCover = data[URL_COVER];
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData.compact(json[ID], json[NAME], json[URL_AVT]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ID] = id;
    data[NAME] = name;
    data[EMAIL] = email;
    data[PHONE] = phone;
    data[WEIGHT] = weight;
    data[HEIGHT] = height;
    data[URL_AVT] = urlAvt;
    data[URL_COVER] = urlCover;
    return data;
  }
}
