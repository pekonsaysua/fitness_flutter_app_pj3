import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/models/user.dart';

class ChallengeModel {
  String id;
  String name;
  String description;

  String begin;
  String end;
  bool isJoin;

  Target target;
  List<UserData> user;

  ChallengeModel(
      this.id, this.name, this.description, this.begin, this.end, this.target);

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      json["id"],
      json["name"],
      json["description"],
      json["begin"],
      json["end"],
      Target.fromJson(json["target"]),
    );
  }
}

class Target {
  String distance;
  String step;
  String calo;
  String time;

  Target(this.distance, this.step, this.calo, this.time);

  factory Target.fromJson(Map<String, dynamic> json) {
    return Target(json["distance"], json["step"], json["calo"], json["time"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["distance"] = distance;
    data["step"] = step;
    return data;
  }
}
