import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
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
      value = await Firestore.instance
          .collection('posts')
          .getDocuments();
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
}
