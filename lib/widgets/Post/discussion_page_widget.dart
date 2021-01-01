import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/post.dart';
import 'package:fitness_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiscussionPage extends StatefulWidget {
  PostModel post;

  DiscussionPage(this.post);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  bool _showKeyboard = false;

  FocusNode focusNode;
  List<UserData> likeList = new List();
  List<CommentModel> commentList = new List();
  bool isLoading = false;

  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });

      await init();

      setState(() {
        isLoading = false;
      });
    });

    focusNode = FocusNode();
    focusNode.addListener(() {
      print('Listener');
    });
  }

  Future<void> init() async {
    likeList = await getListLikes();
    commentList = await getListComments();
  }

  Future<List<CommentModel>> getListComments() async {
    List<CommentModel> listComment = new List();
    try {
      var value = await Firestore.instance
          .collection('posts')
          .document(widget.post.id)
          .collection("comment_list")
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

  Future<List<UserData>> getListLikes() async {
    List<UserData> listLike = new List();
    try {
      var value = await Firestore.instance
          .collection('posts')
          .document(widget.post.id)
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

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void dismissKeyboard() {
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorOrange,
        title: Text("Thao luan"),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (WidgetsBinding.instance.window.viewInsets.bottom >
                          0.0) dismissKeyboard();
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: kColorGrey, width: 0.7)),
                          ),
                          height: 70,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.post.is_liked =
                                                !widget.post.is_liked;
                                          });
                                        },
                                        icon: widget.post.is_liked
                                            ? Icon(
                                                FontAwesomeIcons.solidThumbsUp,
                                                size: 20.0,
                                                color: kColorBlue,
                                              )
                                            : Icon(
                                                FontAwesomeIcons.thumbsUp,
                                                size: 20.0,
                                                color: kColorBlack,
                                              )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(likeList.length.toString()),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 20,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: likeList.length,
                                  itemBuilder: (context, index) {
                                    var avatar = likeList[index].urlAvt;
                                    return CircleAvatar(
                                      backgroundColor: kColorGrey,
                                      radius: 15.0,
                                      backgroundImage: avatar == null
                                          ? AssetImage(
                                              'assets/images/avatar.jpg')
                                          : NetworkImage(avatar),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Center(
                                  child: Icon(Icons.arrow_forward_ios),
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: commentList.length,
                            itemBuilder: (context, index) {
                              var avatar = commentList[index].poster.urlAvt;
                              CommentModel com = commentList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: kColorGrey, width: 0.7)),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: kColorGrey,
                                    radius: 25.0,
                                    backgroundImage: com.poster.urlAvt == null
                                        ? AssetImage('assets/images/avatar.jpg')
                                        : NetworkImage(com.poster.urlAvt),
                                  ),
                                  title: Text(
                                    com.poster.name +
                                        "        * " +
                                        com.created,
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    com.comment,
                                    style: TextStyle(
                                        color: kColorBlack, fontSize: 16),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.more_vert_outlined),
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: TextField(
                    controller: textEditingController,
                    autofocus: false,
                    textInputAction: TextInputAction.send,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Viet thu gi do",
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            String uId = await StorageUtil.getUid();

                            DocumentReference docRef = await Firestore.instance
                                .collection('posts')
                                .document(widget.post.id)
                                .collection('comment_list')
                                .add({
                              "uid": uId,
                              "comment": textEditingController.text,
                              "created": DateTime.now().toString()
                            });
                            Firestore.instance
                                .collection('posts')
                                .document(widget.post.id)
                                .collection('comment_list')
                                .document(docRef.documentID)
                                .updateData({'id': docRef.documentID});
                          },
                          child: Icon(Icons.send),
                        )),
                  ),
                )
              ],
            ),
    );
  }
}
