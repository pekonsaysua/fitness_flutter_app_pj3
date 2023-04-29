import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/ProfilePage/profile_page.dart';
import 'package:flutter/material.dart';

class FindFriend extends StatefulWidget {
  @override
  _FindFriendState createState() => _FindFriendState();
}

class _FindFriendState extends State<FindFriend> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 2);
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    super.initState();
  }

  Future<void> init() async {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kColorOrange,
            title: Text("Tìm bạn bè"),
            bottom: TabBar(
              indicatorColor: kColorWhite,
              controller: _tabController,
              unselectedLabelColor: kColorGrey,
              labelColor: kColorWhite,
              tabs: [
                Tab(
                  text: "ĐỀ NGHỊ",
                ),
                Tab(
                  text: "FACEBOOK",
                ),
              ],
            ),
          ),
          body: new TabBarView(controller: _tabController, children: [
            SuggestedFriend(),
            Scaffold(),
          ]),
        ));
  }
}

class SuggestedFriend extends StatefulWidget {
  @override
  _SuggestedFriendState createState() => _SuggestedFriendState();
}

class _SuggestedFriendState extends State<SuggestedFriend> {
  bool isLoading = true;
  List<UserData> list = List();
  List<bool> followList = List();
  String myId;

  List<Map<String, dynamic>> listMap = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        isLoading = true;
      });

      await init();

      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> init() async {
    myId = await StorageUtil.getUid();
    var doc = await Firestore.instance.collection("users").getDocuments();
    for (var val in doc.documents) {
      Map<String, dynamic> json = val.data;
      UserData user;
      bool isFollow;
      if (json["uid"] != myId) {
        user = new UserData.fromJson(json);
        isFollow = await Api.checkFollowing(myId, user.id);
        listMap
            .add({"user": user.toJson(), "isFollowing": isFollow.toString()});
      }
      list.add(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : ListView.builder(
            itemCount: listMap.length,
            itemBuilder: (_, index) {
              var res = listMap[index];
              var user = UserData.fromJson(res["user"]);
              bool check = res["isFollowing"] == "true" ? true : false;
              return ListTile(
                leading: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: kColorGrey,
                    radius: 20.0,
                    backgroundImage: user.urlAvt == null
                        ? AssetImage('assets/images/avatar.jpg')
                        : NetworkImage(user.urlAvt),
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userId: user.id,
                        ),
                      ),
                    );
                  },
                ),
                title: Text(user.name),
                trailing: check
                    ? FlatButton(
                        textColor: kColorOrange,
                        onPressed: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                              ),
                              context: context,
                              builder: (_) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor)),
                                          ),
                                          child: Text(
                                            "Hành động",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FlatButton(
                                            onPressed: () {
                                              Api.setUnFollow(myId, user.id);
                                              Navigator.pop(context);
                                              setState(() {
                                                listMap[index]["isFollowing"] =
                                                    "false";
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Hủy theo dõi",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: kColorOrange),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Text("Đang theo dõi"),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: kColorOrange, width: 2),
                            borderRadius: BorderRadius.circular(5)),
                      )
                    : FlatButton(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.08),
                        textColor: kColorWhite,
                        onPressed: () async {
                          Api.setFollow(myId, user.id);
                          setState(() {
                            listMap[index]["isFollowing"] = "true";
                          });
                        },
                        child: Text("Theo dõi"),
                        color: kColorOrange,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: kColorOrange, width: 2),
                            borderRadius: BorderRadius.circular(5)),
                      ),
              );
            });
  }
}
