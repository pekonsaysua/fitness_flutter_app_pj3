import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
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

      list = await init();

      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  Future<List<PostModel>> init() async {
    String myId = await StorageUtil.getUid();
    var innerList = await Api.getListPostApi(myId);
    List<String> friendsList = await Api.getFollowingApi(myId);
    for (var i in friendsList) {
      List<PostModel> newList = await Api.getListPostApi(i);
      innerList.addAll(newList);
    }
    if (innerList.isEmpty) innerList = await Api.getListPostApi();
    innerList.sort((a, b) => b.act.date.compareTo(a.act.date));
    list = innerList;
    return innerList;
  }

  Future<void> getAll() async {
    setState(() {
      isLoading = true;
    });

    list = await Api.getListPostApi();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: () async {
            list = await init();
          },
          child: isLoading
              ? Container(
                  color: kColorWhite,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : StreamBuilder(
                  initialData: list,
                  stream: init().asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List snapList = snapshot.data;
                      if (snapList.isEmpty) {
                        return ListView(
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.725,
                              color: kColorWhite,
                              child: Center(
                                child: Text("empty"),
                              ),
                            ),
                          ],
                        );
                      } else
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return PostWidget(snapshot.data[index]);
                            });
                    } else
                      return Text("loi");
                  }),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
