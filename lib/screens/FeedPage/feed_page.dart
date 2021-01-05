import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/post.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/FeedPage/following_page.dart';
import 'package:fitness_app/widgets/Post/post_widget.dart';
import 'package:fitness_app/widgets/user_activities_widet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  UserData user = UserData.empty();

  String userId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(vsync: this, length: 2);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
  }

  Future<void> init() async {
    userId = await StorageUtil.getUid();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kColorOrange,
          automaticallyImplyLeading: false,
          title: Text("Trang chủ"),
          actions: [
            IconButton(
              icon: const Icon(Icons.people_outline),
              color: kColorWhite,
              tooltip: 'Find Friends',
              onPressed: () {},
            ),
            SizedBox(
              width: 15,
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              color: kColorWhite,
              tooltip: 'Notifications',
              onPressed: () {},
            ),
            SizedBox(
              width: 15,
            ),
          ],
          bottom: TabBar(
            indicatorColor: kColorWhite,
            controller: _tabController,
            unselectedLabelColor: kColorGrey,
            labelColor: kColorWhite,
            tabs: [
              Tab(
                text: "ĐANG THEO DÕI",
              ),
              Tab(
                text: "BẠN",
              ),
            ],
          ),
        ),
        body: new TabBarView(
            controller: _tabController,
            children: [FollowingPage(), Scaffold(body: Activity())]),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
