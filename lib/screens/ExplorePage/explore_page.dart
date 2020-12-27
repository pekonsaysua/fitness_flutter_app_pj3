import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kColorOrange,
          automaticallyImplyLeading: false,
          title: Text("Khám phá"),
          actions: [
            IconButton(
              icon: const Icon(Icons.people_outline),
              color: kColorWhite,
              tooltip: 'Find Friends',
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            
            indicatorColor: kColorWhite,
            controller: _tabController,
            unselectedLabelColor: kColorGrey,
            labelColor: kColorWhite,
            labelPadding: EdgeInsets.all(0),
            tabs: [
              Tab(
                text: "CHO BẠN",
              ),
              Tab(
                text: "THỬ THÁCH",
              ),
              Tab(
                text: "CLUB",
              ),
              Tab(
                text: "SEGMENTS",
              ),
            ],
          ),
        ),
        body: new TabBarView(controller: _tabController, children: [
          Scaffold(),
          Scaffold(),
          Scaffold(),
          Scaffold(),
        ]),
      ),
    );
  }
}
