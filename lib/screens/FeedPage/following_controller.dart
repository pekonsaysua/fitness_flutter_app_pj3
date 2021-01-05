import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/models/data_count.dart';
import 'package:fitness_app/models/post.dart';
import 'package:fitness_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class FollowingController extends GetxController {
  StreamController _listPost = new StreamController.broadcast();

  Stream get listPostStream => _listPost.stream;

  Future<List<PostModel>> getListPost() async {
    List<PostModel> listPost = new List();
    _listPost.sink.add("");
    try {
      var value = await Firestore.instance.collection('posts').getDocuments();
      for (var element in value.documents) {
        Map<String, dynamic> json = element.data;
        UserData user = await Api.getUserApi(json["uid"]);
        DataCount act = await Api.getActivityApi(json['actId']);

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
    } catch (e) {
      e.toString();
    }
    print(listPost.length);
    _listPost.sink.add(listPost);
    return listPost;
  }
}
