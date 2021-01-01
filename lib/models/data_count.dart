import 'package:cloud_firestore/cloud_firestore.dart';

class DataCount {
  static const ID = 'id';
  static const ID_USER = 'uid';
  static const STEP = 'step';
  static const DISTANCE = 'distance';
  static const CALORIES = 'calories';
  static const TIME = 'time';
  static const DATE = 'date';
  static const TRACK = 'track';

  String id;
  String uid;
  String step;
  String distance;
  String calories;
  String time;
  String date;
  List<Coordinate> track;

  DataCount(this.id, this.uid, this.step, this.distance, this.calories,
      this.time, this.date, this.track);

  DataCount.formSnapShot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    uid = data[ID_USER];
    step = data[STEP];
    distance = data[DISTANCE];
    time = data[TIME];
    calories = data[CALORIES];
    date = data[DATE];
    track = data[TRACK];
  }

  factory DataCount.fromJson(Map<String, dynamic> json) {
    return DataCount(
      json[ID],
      json[ID_USER],
      json[STEP],
      json[DISTANCE],
      json[CALORIES],
      json[TIME],
      json[DATE],
      List<Coordinate>.from(
          json[TRACK].map((x) => Coordinate.fromJson(x)).toList()),
    );
  }
}

class Coordinate {
  double lat;
  double lng;

  Coordinate(this.lat, this.lng);

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(json["lat"], json["lng"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lat"] = lat;
    data["lng"] = lng;
    return data;
  }
}
