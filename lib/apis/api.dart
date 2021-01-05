import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/helpers/parse_date_helpers.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/challenge.dart';
import 'package:fitness_app/models/data_count.dart';
import 'package:fitness_app/models/post.dart';
import 'package:fitness_app/models/user.dart';

class Api {
  static Future<UserData> getUserApi(String userId) async {
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

  static Future<DataCount> getActivityApi(String actId) async {
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

  //TODO : POST

  static Future<List<PostModel>> getListPostApi([String userId]) async {
    List<PostModel> listPost = new List();
    var value;
    if (userId == null)
      value = await Firestore.instance.collection('posts').getDocuments();
    else
      value = await Firestore.instance
          .collection('posts')
          .where("uid", isEqualTo: userId)
          .getDocuments();
    for (var element in value.documents) {
      Map<String, dynamic> json = element.data;
      UserData user = await Api.getUserApi(json["uid"]);
      DataCount act = DataCount.fromJson(json["activity"]);

      var list = await Api.getListLikesApi(json["id"]);
      var likeNumber = list.length;
      var list2 = await Api.getListCommentsApi(json["id"]);
      var commentNumber = list2.length;
      var check = await Api.checkIslikeApi(user.id, json["id"]);
      PostModel postModel = new PostModel(
          json["id"],
          user,
          act,
          json['type'],
          json["title"],
          json["description"],
          likeNumber.toString(),
          commentNumber.toString(),
          check);
      listPost.add(postModel);
    }
    return listPost;
  }

  //TODO : COMMENT(LIKE)

  static Future<void> setCommentApi(
      String postId, String uid, String comment) async {
    DocumentReference docRef = await Firestore.instance
        .collection('posts')
        .document(postId)
        .collection('comment_list')
        .add({
      "uid": uid,
      "comment": comment,
      "created": DateTime.now().toString()
    });
    Firestore.instance
        .collection('posts')
        .document(postId)
        .collection('comment_list')
        .document(docRef.documentID)
        .updateData({'id': docRef.documentID});
  }

  static Future<List<CommentModel>> getListCommentsApi(String postId) async {
    List<CommentModel> listComment = new List();
    try {
      var value = await Firestore.instance
          .collection('posts')
          .document(postId)
          .collection("comment_list")
          .orderBy('created', descending: true)
          .getDocuments();
      for (var element in value.documents) {
        Map<String, dynamic> json = element.data;
        UserData user = await Api.getUserApi(json["uid"]);
        listComment
            .add(new CommentModel(user, json["comment"], json["created"]));
      }
    } catch (e) {
      e.toString();
    }
    return listComment;
  }

  static Future<List<UserData>> getListLikesApi(String postId) async {
    List<UserData> listLike = new List();
    try {
      var value = await Firestore.instance
          .collection('posts')
          .document(postId)
          .collection("like_list")
          .getDocuments();
      for (var element in value.documents) {
        Map<String, dynamic> json = element.data;
        UserData user = await Api.getUserApi(json["uid"]);
        listLike.add(user);
      }
    } catch (e) {
      e.toString();
    }
    return listLike;
  }

  static Future<bool> checkIslikeApi(String userId, String postId) async {
    var value = await Firestore.instance
        .collection("posts")
        .document(postId)
        .collection("like_list")
        .where("uid", isEqualTo: userId)
        .getDocuments();
    return value.documents.isNotEmpty;
  }

  static Future<bool> setLikeApi(String userId, String postId) async {
    bool check = await checkIslikeApi(userId, postId);
    if (!check) {
      Firestore.instance
          .collection("posts")
          .document(postId)
          .collection("like_list")
          .add({"uid": userId});
    } else {
      var docRef = await Firestore.instance
          .collection("posts")
          .document(postId)
          .collection("like_list")
          .where("uid", isEqualTo: userId)
          .getDocuments();

      Firestore.instance
          .collection("posts")
          .document(postId)
          .collection("like_list")
          .document(docRef.documents.first.documentID)
          .delete();
    }
  }

  static Future<List<String>> getFollowingApi(String followerId) async {
    List<String> list = new List();
    var find = await Firestore.instance
        .collection('friends')
        .where("followerId", isEqualTo: followerId)
        .getDocuments();
    for (var value in find.documents) {
      Map<String, dynamic> json = value.data;
      list.add(json["followingId"]);
    }
    return list;
  }

  static Future<List<String>> getFollowerApi(String followingId) async {
    List<String> list = new List();
    var find = await Firestore.instance
        .collection('friends')
        .where("followingId", isEqualTo: followingId)
        .getDocuments();
    for (var value in find.documents) {
      Map<String, dynamic> json = value.data;
      list.add(json["followerId"]);
    }
    return list;
  }

  static Future<List<ChallengeModel>> getListChallengeApi(String userId,
      [bool isJoin]) async {
    List<ChallengeModel> list = new List();
    String myId = await StorageUtil.getUid();

    if (userId != myId) {
      var doc = await Firestore.instance
          .collection("users_challenges")
          .where("uid", isEqualTo: userId)
          .getDocuments();
      if (doc.documents.isNotEmpty) {
        for (var value in doc.documents) {
          Map<String, dynamic> json = value.data;
          ChallengeModel challengeModel;
          challengeModel = await getChallengeApi(json["challengeId"]);
          list.add(challengeModel);
        }
      }
    } else {
      var doc =
          await Firestore.instance.collection("challenges").getDocuments();
      if (doc.documents.isNotEmpty) {
        for (var value in doc.documents) {
          Map<String, dynamic> json = value.data;
          ChallengeModel challengeModel;
          challengeModel = new ChallengeModel.fromJson(json);
          challengeModel.isJoin = await checkJoinChallenge(myId, json["id"]);
          if (challengeModel.isJoin == isJoin) list.add(challengeModel);
        }
      }
    }
    return list;
  }

  static Future<ChallengeModel> getChallengeApi(String challengeId) async {
    String myId = await StorageUtil.getUid();
    var doc = await Firestore.instance
        .collection("challenges")
        .document(challengeId)
        .get();
    Map<String, dynamic> json = doc.data;

    ChallengeModel challengeModel;
    challengeModel = new ChallengeModel.fromJson(json);
    challengeModel.isJoin = await checkJoinChallenge(myId, json["id"]);

    return challengeModel;
  }

  static Future<List<ChallengeModel>> getListChallengeOfUserApi(
      String userId) async {
    List<ChallengeModel> list = new List();
    var doc = await Firestore.instance
        .collection("users_challenges")
        .where("uid", isEqualTo: userId)
        .getDocuments();
    for (var value in doc.documents) {
      Map<String, dynamic> json = value.data;

      var doc2 = await Firestore.instance
          .collection("challenges")
          .document(json["challengeId"])
          .get();
      Map<String, dynamic> json2 = doc2.data;
      ChallengeModel challengeModel = new ChallengeModel.fromJson(json2);
      list.add(challengeModel);
    }
    return list;
  }

  static Future<void> setJoinChallenge(
      String userId, String challengeId) async {
    Firestore.instance.collection("users_challenges").add({
      "uid": userId,
      "challengeId": challengeId,
      "created": DateTime.now().toString()
    });
  }

  static Future<void> setUnJoinChallenge(
      String userId, String challengeId) async {
    var doc = await Firestore.instance
        .collection("users_challenges")
        .where("uid", isEqualTo: userId)
        .where("challengeId", isEqualTo: challengeId)
        .getDocuments();
    Firestore.instance
        .collection("users_challenges")
        .document(doc.documents.first.documentID)
        .delete();
  }

  static Future<bool> checkJoinChallenge(
      String userId, String challengeId) async {
    var doc = await Firestore.instance
        .collection("users_challenges")
        .where("uid", isEqualTo: userId)
        .where("challengeId", isEqualTo: challengeId)
        .getDocuments();
    return doc.documents.isNotEmpty;
  }

  //TODO : THONG KE
  static Future<Map<String, dynamic>> getStatsApi(String uid, [int day]) async {
    List<DataCount> list = new List();

    var doc = await Firestore.instance
        .collection("posts")
        .where("uid", isEqualTo: uid)
        .getDocuments();
    if (doc.documents.isNotEmpty) {
      for (var i in doc.documents) {
        Map<String, dynamic> json = i.data;
        DataCount dataCount = DataCount.fromJson(json["activity"]);
        if (day == null)
          list.add(dataCount);
        else if (ParseDate.getDay(dataCount.date) <= day) list.add(dataCount);
      }
    }
    var distance = 0.0;
    var calo = 0.0;
    var step = 0;
    var second = 0;
    var minute = 0;
    var hour = 0;
    var time = "00:00";
    for (var dataCount in list) {
      distance = distance + double.parse(dataCount.distance);
      calo = calo + double.parse(dataCount.calories);
      step = step + int.parse(dataCount.step);
      var a = dataCount.time.split(":");
      second = second + int.parse(a.last);
      minute = minute + int.parse(a.first);
    }
    if ((second - second % 60) != 0) minute = minute + 1;
    if ((minute - minute % 60) != 0) hour = hour + 1;
    second = second % 60;
    time = (hour == 0 ? "" : hour.toString() + "h") +
        (minute == 0 ? "" : minute.toString() + "m") +
        second.toString() +
        "s";
    return {
      "count": list.length.toString(),
      "distance": distance.toString(),
      "calo": calo.toString(),
      "step": step.toString(),
      "time": time
    };
  }
}
