import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/models/data_count.dart';
import 'package:fitness_app/models/post.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/FeedPage/following_controller.dart';
import 'package:fitness_app/widgets/Post/post_widget.dart';
import 'package:flutter/material.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage>
    with AutomaticKeepAliveClientMixin {
  FollowingController _followingController = new FollowingController();

  bool isLoading = false;
  List<PostModel> list = List();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      await _followingController.getListPost().then((value) {
        setState(() {
          list = value;
        });
      });
      setState(() {
        isLoading = false;
      });
    });
    
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: isLoading
            ? Container(
                color: kColorWhite,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : list.isEmpty
                ? Container(
                    color: kColorWhite,
                    child: Center(
                      child: Text("empty"),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return PostWidget(list[index]);
                    }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
