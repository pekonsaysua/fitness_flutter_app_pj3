import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/screens/ExplorePage/explore_page.dart';
import 'package:fitness_app/screens/ProfilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/provider/chart_provider.dart';
import 'package:fitness_app/screens/chart_page.dart';
import 'package:fitness_app/screens/HomePage/home_page.dart';
import 'package:fitness_app/screens/MenuPage/target_page.dart';
import 'package:fitness_app/widgets/BottomNavigationBar/bootom_navigation_bar.dart';
import 'package:fitness_app/widgets/home_menu.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/screens/chart_page.dart';
import 'package:fitness_app/screens/FeedPage/feed_page.dart';
import 'package:fitness_app/screens/MenuPage/target_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  PageController _pageController = PageController();

  void _onItemTapped(int index) async {
    if (index == 2) {
      await Navigator.pushNamed(context, "home_screen")
          .then((value) => setState(() {
                _selectedIndex = 0;
                _pageController.jumpToPage(0);
              }));
    } else
      _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        //backgroundColor: Colors.grey[400],
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            FeedPage(),
            ExplorePage(),
            Scaffold(),
            ProfilePage(),
            TargetPage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kColorWhite,
          showSelectedLabels: true,
          selectedItemColor: kColorOrange,
          unselectedItemColor: kColorBlack,
          unselectedLabelStyle: TextStyle(color: kColorBlack),
          showUnselectedLabels: true,
          elevation: 1,
          mouseCursor: MouseCursor.uncontrolled,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                label: "Trang chủ", icon: Icon(Icons.home_filled, size: 30.0)),
            BottomNavigationBarItem(
                label: "Khám phá",
                icon: Icon(Icons.explore_outlined, size: 30.0)),
            BottomNavigationBarItem(
                label: "Theo dõi",
                icon: Icon(Icons.fiber_manual_record_rounded, size: 30.0)),
            BottomNavigationBarItem(
                label: "Cá nhân", icon: Icon(Icons.person_outline, size: 30.0)),
            BottomNavigationBarItem(
                label: "Menu", icon: Icon(Icons.menu, size: 30.0))
          ],
        ),
      ),
    );
  }
}

/*
class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.black54, Colors.lightBlue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: child,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isHomePageSelected = true;
  bool isTargetPageSelected = false;
  bool isChartPageSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        height: 80,
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black54,
          elevation: 5.0,
          title: Text(
            "Running App",
            style: TextStyle(color: Colors.white),
          ),
          leading: FlatButton(
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Colors.white,
              )),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
                onPressed: () {
                  StorageUtil.clear();
                })
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.black, Colors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: isHomePageSelected
              ? HomePage()
              : (isTargetPageSelected ? TargetPage() : ChartPage()),
        ),

      ),
      //-----------------Bottom Bar--------------------
      bottomNavigationBar:
          CustomBottomNavigationBar(onIconPresedCallback: onBottomIconPressed),
      //----------------Drawer View--------------------
      drawer: HomeMenu(),
    );
  }

  void onBottomIconPressed(int index) {
    switch (index) {
      case 0:
        setState(() {
          isHomePageSelected = false;
          isTargetPageSelected = true;
          isChartPageSelected = false;
        });
        break;
      case 1:
        setState(() {
          isHomePageSelected = true;
          isTargetPageSelected = false;
          isChartPageSelected = false;
        });
        break;
      case 2:
        setState(() {
          isHomePageSelected = false;
          isTargetPageSelected = false;
          isChartPageSelected = true;
        });
        break;
    }
  }
}

 */
