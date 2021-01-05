import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/ProfilePage/follow_page.dart';
import 'package:fitness_app/screens/ProfilePage/profile_controller.dart';
import 'package:fitness_app/screens/ProfilePage/statistic_page.dart';
import 'package:fitness_app/widgets/user_activities_widet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/provider/user_provider.dart';

class ProfilePage extends StatefulWidget {
  final UserData userData;

  const ProfilePage({Key key, this.userData}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  UserData myProfile;

  UserData user = new UserData.empty();

  bool isFollow = false;
  bool isLoading = true;

  ProfileController profileController;

  List<String> followerList = new List();
  List<String> followingList = new List();

  @override
  void initState() {
    // TODO: implement initState
    //init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => isLoading = true);
      await init();
      setState(() => isLoading = false);
    });
    super.initState();
  }

  Future<void> init() async {
    profileController = new ProfileController();

    myProfile = await StorageUtil.getUserInfo();

    user = widget.userData ?? myProfile;
    print(myProfile.id + ", " + user.id);
    if (user.id != myProfile.id) {
      isFollow = await profileController.checkFollower(
          myProfile.id, widget.userData.id);
    }

    followerList = await profileController.getFollower(user.id);
    followingList = await profileController.getFollowing(user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: kColorOrange,
        automaticallyImplyLeading: widget.userData != null,
        title: Text("Trang cá nhân"),
        actions: [
          isLoading
              ? SizedBox()
              : user.id != myProfile.id
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(context, 'edit_profile_screen');
                      },
                      tooltip: "Edit Profile",
                    ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "setting_screen");
            },
            tooltip: "Settings",
          ),
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {},
            tooltip: "Share Profile",
          )
        ],
      ),
      body: isLoading
          ? Container(
              color: kColorWhite,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: kColorWhite,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 15),
                          child: Row(
                            children: [
                              user.urlAvt == null
                                  ? CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage(
                                          "assets/images/avatar.jpg"))
                                  : CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          NetworkImage(user.urlAvt)),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                user.name ?? "Null",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FollowPage(
                                                  0,
                                                  followerList,
                                                  followingList)));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Theo dõi bạn",
                                          style: TextStyle(color: kColorOrange),
                                        ),
                                        Text(followerList.length.toString()),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color:
                                                Theme.of(context).dividerColor,
                                            width: 1,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FollowPage(
                                                  1,
                                                  followerList,
                                                  followingList)));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Đang theo dõi",
                                          style: TextStyle(color: kColorOrange),
                                        ),
                                        Text(followingList.length.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              user.id == myProfile.id
                                  ? FlatButton(
                                      textColor: kColorOrange,
                                      onPressed: () {},
                                      child: Text("Tìm bạn bè"),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: kColorOrange, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    )
                                  : isFollow
                                      ? FlatButton(
                                          textColor: kColorOrange,
                                          onPressed: () {
                                            showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15)),
                                                ),
                                                context: context,
                                                builder: (_) {
                                                  return SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    child: Container(),
                                                  );
                                                });
                                          },
                                          child: Text("Đang theo dõi"),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: kColorOrange,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        )
                                      : FlatButton(
                                          textColor: kColorWhite,
                                          onPressed: () async {
                                            await profileController.setFollow(
                                                myProfile.id,
                                                widget.userData.id);
                                            setState(() {
                                              isFollow = true;
                                            });
                                          },
                                          child: Text("Theo dõi"),
                                          color: kColorOrange,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: kColorOrange,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 15),
                    color: kColorWhite,
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        backgroundColor: kColorOrange,
                                        title: Text("Hoạt động"),
                                      ),
                                      backgroundColor: Colors.grey[300],
                                      body: Activity(
                                        userId: user.id,
                                      )),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: Icon(Icons.local_activity_outlined),
                              title: Text("Hoạt động"),
                              trailing: Icon(Icons.arrow_forward_ios),
                            )),
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StatisticPage(user.id),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: Icon(Icons.table_rows_outlined),
                              title: Text("Thống kê"),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                            shape: Border(
                                top: BorderSide(color: kColorGrey, width: 0.5),
                                bottom:
                                    BorderSide(color: kColorGrey, width: 0.5))),
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {},
                            child: ListTile(
                              leading: Icon(Icons.featured_play_list_outlined),
                              title: Text("Bài viết"),
                              trailing: Icon(Icons.arrow_forward_ios),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    color: kColorWhite,
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Thử thách",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text("1"),
                            ],
                          ),
                        ),
                        Container(
                          height: 100.0,
                          padding: EdgeInsets.only(bottom: 20, left: 15),
                          child: ListView(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  child: Container(
                                    height: 100,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: ListTile(
                                      leading: Icon(Icons.padding),
                                      title: Text("Thu thach chay thang 12"),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("50km"),
                                          Text("Con 1 ngay"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  child: Container(
                                    height: 100,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: ListTile(
                                      leading: Icon(Icons.padding),
                                      title: Text("Thu thach chay thang 12"),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("50km"),
                                          Text("Con 1 ngay"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                            shape: Border(
                              top: BorderSide(color: kColorGrey, width: 0.5),
                            ),
                            padding: EdgeInsets.all(0),
                            onPressed: () {},
                            child: ListTile(
                              leading: Text("Tất cả"),
                              trailing: Icon(Icons.arrow_forward_ios),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    color: kColorWhite,
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Câu lạc bộ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text("5"),
                            ],
                          ),
                        ),
                        Container(
                          height: 100.0,
                          padding: EdgeInsets.only(bottom: 20, left: 15),
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  child: Container(
                                    height: 100,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: ListTile(
                                      leading: Icon(Icons.padding),
                                      title: Text("Thu thach chay thang 12"),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("50km"),
                                          Text("Con 1 ngay"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  child: Container(
                                    height: 100,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: ListTile(
                                      leading: Icon(Icons.padding),
                                      title: Text("Thu thach chay thang 12"),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("50km"),
                                          Text("Con 1 ngay"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                            shape: Border(
                              top: BorderSide(color: kColorGrey, width: 0.5),
                            ),
                            padding: EdgeInsets.all(0),
                            onPressed: () {},
                            child: ListTile(
                              leading: Text("Tất cả"),
                              trailing: Icon(Icons.arrow_forward_ios),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/*

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _key = GlobalKey<ScaffoldState>();
  String avtUrl;
  String coverUrl;
  bool _allowEdit = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _uid;
  File _imageAvt;
  File _imageCover;
  UserData userFake;

  String triAva = "https://scontent.fhan3-3.fna.fbcdn.net/v/t1.0-9/41371619_468795623638651_1824831978009001984_o.jpg?_nc_cat=106&ccb=2&_nc_sid=09cbfe&_nc_ohc=Ff-A6AlOKy8AX-Q2xZz&_nc_ht=scontent.fhan3-3.fna&oh=67a9a268348a584576a0fc4eb9543076&oe=5FE4DBEF";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUserInfo().then((value) => setState((){
      userFake = value;
    }));
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    _phoneController.text = user.userData.phone;
    _nameController.text = user.userData.name;
    _heightController.text = user.userData.height;
    _weightController.text = user.userData.weight;
    _uid = user.userData.id;
    avtUrl = user.userData.urlAvt;
    coverUrl = user.userData.urlCover;

    Future getImageAvt() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageAvt = image;
      });
    }
    Future getImageCover() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageCover = image;
      });
    }

    //----------Cập nhật avatar---------------
    Future uploadAvt(BuildContext context) async{
      String fileName = basename(_imageAvt.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageAvt);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        avtUrl = url;
        user.updateAvt(_uid, url);
        _imageAvt = null;
        });
    }
    //----------Cập nhật cover--------------
    Future uploadCover(BuildContext context) async{
      String fileName = basename(_imageCover.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageCover);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        coverUrl = url;
        user.updateCover(_uid, url);
        _imageCover = null;
      });
    }

    return Scaffold(
        key: _key,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black54,
                  Colors.blue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
          ),
          child: ListView(
            children: <Widget>[
              //-------APP BAR------------
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.blue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                ),
                child: AppBar(
                  backgroundColor: Colors.black38,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        if(_allowEdit==true){
                          showDialog(context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("Thông báo"),
                                  content: Text("Bạn sẽ thoát và không lưu?"),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, 'main_screen');
                                      },
                                      child: Text("Thoát",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          _imageAvt = null;
                                          _imageCover = null;
                                          _allowEdit = false;
                                        });
                                        Navigator.pushNamed(context, 'main_screen');
                                      },
                                      child: Text("Đồng ý",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  ],
                                );
                              }
                          );
                        }
                        else Navigator.pop(context);
                      }),
                  actions: <Widget>[
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.star_border),
                      onPressed: () {},
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _allowEdit = true;
                        });
                      },
                    ),
                  ],
                ),
              ),


              Stack(
                children: <Widget>[
                  //----------COVER----------
                  Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        color: Colors.white,
                        child: (_imageCover!=null)? Image.file(_imageCover,fit: BoxFit.fill,):
                        Image.network(coverUrl??triAva, fit: BoxFit.fill,)
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        color: _allowEdit ? Colors.black38 : Colors.transparent,
                        child: IconButton(
                          icon:Icon(Icons.add_a_photo, color: _allowEdit ? Colors.white : Colors.transparent,),
                          onPressed: _allowEdit ? (){
                            getImageCover();
                          } : null,
                        ),
                      ),
                    ],
                  ),

                  //-------AVATAR----------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 150, 0, 0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        ClipOval(
                            child: SizedBox(
                                width: 120,
                                height: 120,
                                child: (_imageAvt!=null)? Image.file(_imageAvt,fit: BoxFit.fill,):
                                Image.network(avtUrl??triAva, fit: BoxFit.fill,)
                            )
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: _allowEdit ? Colors.black38 : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: IconButton(
                            icon:Icon(Icons.add_a_photo, color: _allowEdit ? Colors.white : Colors.transparent,size: 15,),
                            onPressed: _allowEdit ? (){
                              getImageAvt();
                            } : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //--------------EMAIL------------------
                    Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            "Email",
                            style: TextStyle(
                                fontSize: 18, color: Colors.blueAccent),
                          ),
                          subtitle: Text(
                            user.userData.email,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                    ),

                    //--------------NAME------------------
                    Card(
                      child: ListTile(
                          leading: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            "Họ Tên",
                            style: TextStyle(
                                fontSize: 18, color: Colors.blueAccent),
                          ),
                          subtitle: Text(
                            user.userData.name,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: _allowEdit ? IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("Họ Tên"),
                                        content: TextField(
                                          controller: _nameController,
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: (){
                                              user.setName(_nameController.text);
                                              Navigator.of(context).pop(context);
                                            },
                                            child: Text("Lưu",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: (){
                                              _nameController.text = user.userData.name;
                                              Navigator.of(context).pop(context);
                                            },
                                            child: Text("Thoát",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              }): null
                      ),
                    ),

                    //--------------PHONE------------------
                    Card(
                      child: ListTile(
                          leading: Icon(
                            Icons.phone,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            "Điện thoại",
                            style: TextStyle(
                                fontSize: 18, color: Colors.blueAccent),
                          ),
                          subtitle: Text(
                            user.userData.phone,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: _allowEdit ? IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("Điện thoại"),
                                        content: TextField(
                                          controller: _phoneController,
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: (){
                                              user.setPhone(_phoneController.text);
                                              Navigator.of(context).pop(context);
                                            },
                                            child: Text("Lưu",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: (){
                                              _phoneController.text = user.userData.phone;
                                              Navigator.of(context).pop(context);
                                            },
                                            child: Text("Thoát",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          )
                                        ],
                                      );
                                    });

                              }): null
                      ),
                    ),

                    //--------------WEIGHT------------------
                    Card(
                      child: ListTile(
                          leading: Icon(
                            Icons.accessibility,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            "Cân nặng",
                            style: TextStyle(
                                fontSize: 18, color: Colors.blueAccent),
                          ),
                          subtitle: Text(
                            user.userData.weight + " kg",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: _allowEdit ? IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("Cân nặng"),
                                        content: TextField(
                                          controller: _weightController,
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: (){
                                              user.setWeight(_weightController.text);
                                              Navigator.of(context).pop(context);
                                            },
                                            child: Text("Lưu",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: (){
                                              _weightController.text = user.userData.weight;
                                              Navigator.of(context).pop(context);
                                            },
                                            child: Text("Thoát",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          )
                                        ],
                                      );
                                    });

                              }): null
                      ),
                    ),

                    //--------------HEIGHT------------------
                    Card(
                      child: ListTile(
                          leading: Icon(
                            Icons.nature_people,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            "Chiều cao",
                            style: TextStyle(
                                fontSize: 18, color: Colors.blueAccent),
                          ),
                          subtitle: Text(
                            user.userData.height + " m",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: _allowEdit ? IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("Chiều cao"),
                                        content: TextField(
                                          controller: _heightController,
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: (){
                                              user.setHeight(_heightController.text);
                                              Navigator.of(context).pop(context);
                                            },
                                            child: Text("Lưu",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: (){
                                              _heightController.text = user.userData.height;
                                              Navigator.of(context).pop(context);
                                            },
                                            child: Text("Thoát",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          )
                                        ],
                                      );
                                    });

                              }): null
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: _allowEdit ? Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.blue,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            //--------BUTTON SAVE--------------
            SizedBox(
              height: 50,
              width: 150,
              child: RaisedButton(
                color: Colors.green,
                child: Text("LƯU",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                onPressed: (){
                  if(_imageAvt!=null)
                    uploadAvt(context);
                  if(_imageCover!=null)
                    uploadCover(context);
                  user.updateDataUser(_uid,_nameController.text,
                  _phoneController.text,
                  _weightController.text,
                  _heightController.text);
                  setState(() {
                    _allowEdit = false;
                  });
                },
              ),
            ),

            //---------BUTTON CANCEL------------
            SizedBox(
              height: 50,
              width: 150,
              child: RaisedButton(
                color: Colors.red,
                child: Text("HỦY",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                onPressed: (){
                  setState(() {
                    _imageAvt = null;
                    _imageCover = null;
                    _allowEdit = false;
                  });
                },
              ),
            ),
          ],
        ),
      ): null,
    );

  }
}


 */
