import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Future<bool> checkFollower(String myId, String yourId) async {
    bool a;
    try {
      var check = await Firestore.instance
          .collection('friends')
          .where("followerId", isEqualTo: myId)
          .where("followingId", isEqualTo: yourId)
          .getDocuments();
      a = check.documents.isNotEmpty;
      print(a);
    } catch (e) {}
    print(a);
    return a;
  }

  Future<bool> checkFollowing(String myId, String yourId) async {
    var check = await Firestore.instance
        .collection('friends')
        .where("followerId", isEqualTo: myId)
        .where("followingId", isEqualTo: yourId);

    return check == null;
  }

  Future<void> setFollow(String myId, String yourId) async {
    DocumentReference docRef =
        await Firestore.instance.collection('friends').add({
      'followerId': myId,
      'followingId': yourId,
    });
  }

  Future<void> unFollow(String myId, String yourId) async {
    var find = await Firestore.instance
        .collection('friends')
        .where("followerId", isEqualTo: myId)
        .where("followingId", isEqualTo: yourId)
        .getDocuments();
    Firestore.instance
        .collection('friends')
        .document(find.documents.first.documentID);
  }

  Future<List<String>> getFollowing(String followerId) async {
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

  Future<List<String>> getFollower(String followingId) async {
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
