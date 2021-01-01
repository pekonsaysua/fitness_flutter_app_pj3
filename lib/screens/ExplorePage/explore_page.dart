import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/screens/ExplorePage/challenges_page.dart';
import 'package:fitness_app/screens/ExplorePage/club_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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
              onPressed: () {
                String a = "LatLng(20.8588093, 105.91791169999999)";
                print(a as LatLng);
              },
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
          Scaffold(
            body: ChallengesPage(),
          ),
          Scaffold(body: ClubPage(),),
          Scaffold(),
          Scaffold(),
        ]),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
