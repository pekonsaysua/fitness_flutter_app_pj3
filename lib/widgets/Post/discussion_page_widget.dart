import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/parse_date_helpers.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/post.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/ProfilePage/profile_page.dart';
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

  String myId = "";

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
    myId = await StorageUtil.getUid();
    likeList = await Api.getListLikesApi(widget.post.id);
    commentList = await Api.getListCommentsApi(widget.post.id);
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
        title: Text("Thảo luận"),
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
                      physics: ScrollPhysics(),
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
                                        onPressed: () async {
                                          setState(() {
                                            widget.post.is_liked =
                                                !widget.post.is_liked;

                                            widget.post.like = widget
                                                    .post.is_liked
                                                ? (int.parse(widget.post.like) +
                                                        1)
                                                    .toString()
                                                : (int.parse(widget.post.like) -
                                                        1)
                                                    .toString();
                                          });
                                          String uid =
                                              await StorageUtil.getUid();
                                          Api.setLikeApi(uid, widget.post.id);
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
                                    Text(widget.post.like),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  physics: ScrollPhysics(),
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
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: commentList.length,
                            itemBuilder: (context, index) {
                              CommentModel com = commentList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: kColorGrey, width: 0.7)),
                                ),
                                child: ListTile(
                                  leading: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                            userData: com.poster,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: kColorGrey,
                                      radius: 25.0,
                                      backgroundImage: com.poster.urlAvt == null
                                          ? AssetImage(
                                              'assets/images/avatar.jpg')
                                          : NetworkImage(com.poster.urlAvt),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        com.poster.name,
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ParseDate.getDay(com.created) == 0
                                          ? ParseDate.getHour(com.created) == 0
                                              ? Text("Vua xong")
                                              : Text(
                                                  ParseDate.getHour(com.created)
                                                          .toString() +
                                                      " gio truoc")
                                          : Text(ParseDate.getDay(com.created)
                                                  .toString() +
                                              " ngay truoc"),
                                    ],
                                  ),
                                  subtitle: Text(
                                    com.comment,
                                    style: TextStyle(
                                        color: kColorBlack, fontSize: 16),
                                  ),
                                  trailing: PopupMenuButton(
                                    onSelected: (myChoose) {
                                      print(myChoose);
                                      setState(() {
                                        commentList.removeAt(index);
                                      });
                                    },
                                    offset: Offset(500, 1000),
                                    itemBuilder: (_) => <PopupMenuItem<String>>[
                                      myId == com.poster.id
                                          ? PopupMenuItem<String>(
                                              child: new Text('Xóa bình luận'),
                                              value: 'delete',
                                            )
                                          : PopupMenuItem<String>(
                                              child: new Text('Ẩn bình luận'),
                                              value: 'hide',
                                            ),
                                    ],
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
                  child: Container(
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      controller: textEditingController,
                      autofocus: false,
                      textInputAction: TextInputAction.send,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Viết thứ gì đó",
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              var text = textEditingController.text;
                              textEditingController.text = "";
                              dismissKeyboard();

                              DocumentReference docRef = await Firestore
                                  .instance
                                  .collection('posts')
                                  .document(widget.post.id)
                                  .collection('comment_list')
                                  .add({
                                "uid": myId,
                                "comment": text,
                                "created": DateTime.now().toString()
                              });
                              Firestore.instance
                                  .collection('posts')
                                  .document(widget.post.id)
                                  .collection('comment_list')
                                  .document(docRef.documentID)
                                  .updateData({'id': docRef.documentID});

                              await Api.getListCommentsApi(widget.post.id)
                                  .then((value) => setState(() {
                                        commentList = value;
                                      }));
                            },
                            child: Icon(Icons.send),
                          )),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
