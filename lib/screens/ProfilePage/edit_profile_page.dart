import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _key = GlobalKey<ScaffoldState>();
  String avtUrl;
  String coverUrl;
  bool _allowEdit = true;
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userFake = await StorageUtil.getUserInfo();
    });
    StorageUtil.getUserInfo().then((value) => setState((){
      userFake = value;
    }));
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    _phoneController.text = userFake.phone;
    _nameController.text = userFake.name;
    _heightController.text = userFake.height;
    _weightController.text = userFake.weight;
    _uid = userFake.id;
    avtUrl = userFake.urlAvt;
    coverUrl = userFake.urlCover;



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
      appBar: AppBar(
        backgroundColor: kColorOrange,
        title: Text("Edit Profile"),
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
      body: Container(
        child: ListView(
          children: <Widget>[
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
