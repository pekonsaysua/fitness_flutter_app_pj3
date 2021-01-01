import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/data_count.dart';
import 'package:fitness_app/models/post.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/ProfilePage/edit_profile_page.dart';
import 'package:fitness_app/screens/ProfilePage/profile_page.dart';
import 'package:fitness_app/widgets/MapWidget/image_map_widget.dart';
import 'package:fitness_app/widgets/Post/discussion_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostWidget extends StatefulWidget {
  PostModel post;

  PostWidget(this.post);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  List<LatLng> convertCoordinate() {
    List<LatLng> latlngs = new List();
    for (var i in widget.post.act.track) latlngs.add(new LatLng(i.lat, i.lng));
    return latlngs;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorWhite,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: kColorGrey,
                    radius: 20.0,
                    backgroundImage: widget.post.user.urlAvt == null
                        ? AssetImage('assets/images/avatar.jpg')
                        : NetworkImage(widget.post.user.urlAvt),
                  ),
                  onTap: () async {
                    UserData myProfile = await StorageUtil.getUserInfo();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                            userData: myProfile.id == widget.post.user.id
                                ? null
                                : widget.post.user),
                      ),
                    );
                  },
                ),
                SizedBox(width: 7.0),
                Expanded(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.post.user.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      //SizedBox(height: 0.0),
                      Text(widget.post.act.date)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Distance"),
                    Text(widget.post.act.distance),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Steps"),
                    Text(widget.post.act.step),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Calories"),
                    Text(widget.post.act.calories),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time"),
                    Text(widget.post.act.time),
                  ],
                )),
              ],
            ),
          ),
          if (widget.post.act.track != null) ImageMap(convertCoordinate()),
          Container(
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                FlatButton(
                  //padding: EdgeInsets.symmetric(vertical: 0),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.thumbsUp, size: 15.0),
                          Text('${widget.post.like}'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('${widget.post.comment} bình luận  •  '),
                          Text('0 chia sẻ'),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                      onPressed: () {
                        setState(() {
                          widget.post.is_liked = !widget.post.is_liked;
                        });
                      },
                      child: widget.post.is_liked
                          ? Icon(
                              FontAwesomeIcons.solidThumbsUp,
                              size: 20.0,
                              color: kColorBlue,
                            )
                          : Icon(
                              FontAwesomeIcons.thumbsUp,
                              size: 20.0,
                            ),
                    )),
                    Expanded(
                      child: FlatButton(
                        onPressed: () async {
                          //await showComment(context, true);
                          List<CommentModel> comList = new List();
                          List<UserData> likeList = new List();

                          likeList.add(new UserData(
                              "1",
                              "hieu",
                              "email",
                              "phone",
                              "123456",
                              "weight",
                              "height",
                              null,
                              null));
                          likeList.add(new UserData(
                              "1",
                              "hieu",
                              "email",
                              "phone",
                              "123456",
                              "weight",
                              "height",
                              null,
                              null));
                          likeList.add(new UserData(
                              "1",
                              "hieu",
                              "email",
                              "phone",
                              "123456",
                              "weight",
                              "height",
                              null,
                              null));
                          likeList.add(new UserData(
                              "1",
                              "hieu",
                              "email",
                              "phone",
                              "123456",
                              "weight",
                              "height",
                              null,
                              null));
                          likeList.add(new UserData(
                              "1",
                              "hieu",
                              "email",
                              "phone",
                              "123456",
                              "weight",
                              "height",
                              null,
                              null));
                          likeList.add(new UserData(
                              "1",
                              "hieu",
                              "email",
                              "phone",
                              "123456",
                              "weight",
                              "height",
                              null,
                              null));
                          comList.add(new CommentModel(
                              new UserData("1", "hieu", "email", "phone",
                                  "123456", "weight", "height", null, null),
                              "hello",
                              "today"));
                          comList.add(new CommentModel(
                              new UserData("1", "hieu", "email", "phone",
                                  "123456", "weight", "height", null, null),
                              "hello",
                              "today"));
                          comList.add(new CommentModel(
                              new UserData("1", "hieu", "email", "phone",
                                  "123456", "weight", "height", null, null),
                              "hello",
                              "today"));
                          comList.add(new CommentModel(
                              new UserData("1", "hieu", "email", "phone",
                                  "123456", "weight", "height", null, null),
                              "hello",
                              "today"));

                          list_post[0].like_list = likeList;
                          list_post[0].comment_list = comList;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscussionPage(widget.post),
                            ),
                          );
                        },
                        child: Icon(FontAwesomeIcons.commentAlt, size: 20.0),
                      ),
                    ),
                    //if (widget.username != widget.post.author.username)
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          //print(widget.post.id);
                        },
                        child: Icon(Icons.share_outlined, size: 20.0),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
