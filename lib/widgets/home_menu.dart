import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/provider/user_provider.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  UserData userFake;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUserInfo().then((value) => setState(() {
          userFake = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          //Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.blue,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            accountName: Text(
              userFake.name ?? 'hele',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(userFake.email??'hihi'),
            currentAccountPicture: GestureDetector(
              child: ClipOval(
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.network(
                        "https://scontent.fhan3-3.fna.fbcdn.net/v/t1.0-9/41371619_468795623638651_1824831978009001984_o.jpg?_nc_cat=106&ccb=2&_nc_sid=09cbfe&_nc_ohc=Ff-A6AlOKy8AX-Q2xZz&_nc_ht=scontent.fhan3-3.fna&oh=67a9a268348a584576a0fc4eb9543076&oe=5FE4DBEF",
                        fit: BoxFit.fill,
                      ))),
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'profile_screen');
            },
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: Text(
                "Thông tin cá nhân",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(
                Icons.help,
                color: Colors.blue,
              ),
              title: Text(
                "Trợ giúp & Liên hệ",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              user.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              StorageUtil.clear();
            },
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
              title: Text(
                "Đăng xuất",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
