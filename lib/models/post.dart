import 'package:fitness_app/models/data_count.dart';
import 'package:fitness_app/models/user.dart';

class PostModel {
  String id;

  UserData user;
  DataCount act;

  String type;

  String title;
  String description;

  String like;
  String comment;
  bool is_liked;

  List<CommentModel> comment_list;
  List<UserData> like_list;

  PostModel(this.id, this.user, this.act, this.type, this.title,
      this.description, this.like, this.comment, this.is_liked);
}

class CommentModel {
  UserData poster;
  String comment;
  String created;

  CommentModel(this.poster, this.comment, this.created);

  CommentModel.empty();

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      UserData.fromJson(json['poster']),
      json['comment'],
      json["created"],
    );
  }

  Map toJson() {
    return {'poster': poster.toJson(), 'comment': comment, 'created': created};
  }
}

/*

List<PostModel> list_post = [
  new PostModel(
      "1234",
      new UserData.compact("id", "name", null),
      new DataCount("1", "1", "10", "0.2795", "81.656", "00:46",
          "2020-12-28 16:05:50.962584", [
        new Coordinate(20.8588101, 105.91791319999999),
        new Coordinate(20.8588099, 105.91791160000002),
        new Coordinate(20.860254228004628, 105.91987576335669),
        new Coordinate(20.860700992217296, 105.91609921306372)
      ]),
      "run",
      "night run",
      "OK",
      "0",
      "1",
      false),
  new PostModel(
      "1234",
      new UserData.compact("id", "name", null),
      new DataCount("1", "1", "10", "0.2795", "81.656", "00:46",
          "2020-12-28 16:05:50.962584", [
        new Coordinate(20.8588101, 105.91791319999999),
        new Coordinate(20.8588099, 105.91791160000002),
        new Coordinate(20.860254228004628, 105.91987576335669),
        new Coordinate(20.860700992217296, 105.91609921306372)
      ]),
      "run",
      "night run",
      "OK",
      "0",
      "1",
      false),
];


 */
