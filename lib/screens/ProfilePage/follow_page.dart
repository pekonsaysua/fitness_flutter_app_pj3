import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:flutter/material.dart';

class FollowPage extends StatefulWidget {
  List<String> userId;

  FollowPage(this.userId);

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kColorOrange,
            title: Text("Theo doi"),
            bottom: TabBar(
              indicatorColor: kColorWhite,
              controller: _tabController,
              unselectedLabelColor: kColorGrey,
              labelColor: kColorWhite,
              tabs: [
                Tab(
                  text: "THEO DOI BAN",
                ),
                Tab(
                  text: "DANG THEO DOI",
                ),
              ],
            ),
          ),
          body: new TabBarView(controller: _tabController, children: [
            Scaffold(),
            Scaffold(
              backgroundColor: kColorWhite,
            ),
          ]),
        ));
  }
}
