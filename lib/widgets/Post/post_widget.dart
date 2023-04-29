import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/parse_date_helpers.dart';
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
                          userId: widget.post.user.id,
                        ),
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
                      ParseDate.getDay(widget.post.act.date) == 0
                          ? Text("Hôm nay")
                          : Text(ParseDate.getDay(widget.post.act.date)
                                  .toString() +
                              " ngày trước"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.post.description != null)
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.only(bottom: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.post.description,
                  style: TextStyle(color: kColorGrey),
                )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quãng đường",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(widget.post.act.distance),
                  ],
                ),
                SizedBox(
                  width: 4,
                ),
                Container(
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 4,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Số bước chân",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(widget.post.act.step),
                  ],
                ),
                SizedBox(
                  width: 4,
                ),
                Container(
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 4,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Calo ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(widget.post.act.calories),
                  ],
                ),
                SizedBox(
                  width: 4,
                ),
                Container(
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 4,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thời gian",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(widget.post.act.time),
                  ],
                ),
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
                          Text(widget.post.like),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(widget.post.comment + ' bình luận  •  '),
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
                      onPressed: () async {
                        setState(() {
                          widget.post.is_liked = !widget.post.is_liked;
                          widget.post.like = widget.post.is_liked
                              ? (int.parse(widget.post.like) + 1).toString()
                              : (int.parse(widget.post.like) - 1).toString();
                        });
                        String uid = await StorageUtil.getUid();
                        Api.setLikeApi(uid, widget.post.id);
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
                          print(DateTime.now()
                              .difference(DateTime.parse(widget.post.act.date))
                              .inHours);
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
