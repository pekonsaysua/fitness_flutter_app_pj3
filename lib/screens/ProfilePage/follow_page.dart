import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/ProfilePage/profile_page.dart';
import 'package:flutter/material.dart';

class FollowPage extends StatefulWidget {
  int tabNumber;

  List<String> followerList;
  List<String> followingList;

  FollowPage(this.tabNumber, this.followerList, this.followingList);

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 2);
    _tabController.animateTo(widget.tabNumber);
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
            title: Text("Theo dõi"),
            bottom: TabBar(
              indicatorColor: kColorWhite,
              controller: _tabController,
              unselectedLabelColor: kColorGrey,
              labelColor: kColorWhite,
              tabs: [
                Tab(
                  text: "THEO DÕI BẠN",
                ),
                Tab(
                  text: "ĐANG THEO DÕI",
                ),
              ],
            ),
          ),
          body: new TabBarView(controller: _tabController, children: [
            FollowerAndFollowingList(false, widget.followerList),
            FollowerAndFollowingList(true, widget.followingList),
          ]),
        ));
  }
}

class FollowerAndFollowingList extends StatefulWidget {
  bool isFollowingList;
  List<String> userIdList;

  FollowerAndFollowingList(this.isFollowingList, this.userIdList);

  @override
  _FollowerAndFollowingListState createState() =>
      _FollowerAndFollowingListState();
}

class _FollowerAndFollowingListState extends State<FollowerAndFollowingList>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  List list = new List();

  String myId;

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
  }

  Future<void> init() async {
    myId = await StorageUtil.getUid();
    for (var userId in widget.userIdList) {
      UserData user = await Api.getUserApi(userId);
      list.add(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : list.isEmpty
              ? Container(
                  child: Center(
                    child: Text("empty"),
                  ),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    UserData user = list[index];
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
                      trailing: widget.isFollowingList
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
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Theme.of(
                                                                  context)
                                                              .dividerColor)),
                                                ),
                                                child: Text(
                                                  "Hành động",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: FlatButton(
                                                  onPressed: () {
                                                    Api.setUnFollow(
                                                        myId, user.id);
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      widget.isFollowingList =
                                                          false;
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
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
                                  side:
                                      BorderSide(color: kColorOrange, width: 2),
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
                                  widget.isFollowingList = true;
                                });
                              },
                              child: Text("Theo dõi"),
                              color: kColorOrange,
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: kColorOrange, width: 2),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                    );
                  }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
