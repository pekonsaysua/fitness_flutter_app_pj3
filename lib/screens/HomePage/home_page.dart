import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/config/initialization.dart';
import 'package:fitness_app/provider/home_provider.dart';
import 'package:fitness_app/provider/timer_provider.dart';
import 'package:fitness_app/provider/user_provider.dart';
import 'package:fitness_app/widgets/chart_view.dart';
import 'package:fitness_app/widgets/count_view.dart';
import 'package:fitness_app/widgets/google_map.dart';
import 'package:fitness_app/widgets/loading.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 1.0,
        automaticallyImplyLeading: true,
        backgroundColor: kColorWhite,
        centerTitle: true,
        title: Text(
          "Hoạt động",
          style: TextStyle(color: kColorOrange),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            //---------------Map View------------------------
            //(time.statusLoading == Status.Authenticating) ? Container(height: 350,child: Loading()) :
            MapView(),

            RunControl()
          ],
        ),
      ),
    );
  }
}

class RunControl extends StatefulWidget {
  @override
  _RunControlState createState() => _RunControlState();
}

class _RunControlState extends State<RunControl> {
  bool isStarting = false;
  bool isPausing = false;
  bool isStopping = true;
  bool isHomePageSelected = true;
  bool isProfilePageSelected = false;
  PanelController _panelController = new PanelController();

  void _togglePanel() {
    if (_panelController.isPanelClosed()) {
      _panelController.open();
    } else {
      _panelController.close();
    }
  }

  UserData userData;

  TextEditingController descriptionTextController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    StorageUtil.getUserInfo().then((value) => setState(() {
          userData = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final time = Provider.of<TimerProvider>(context);
    final home = Provider.of<HomeProvider>(context);
    final user = Provider.of<UserProvider>(context, listen: false);
    return SlidingUpPanel(
      controller: _panelController,
      slideDirection: SlideDirection.UP,
      minHeight: 60,
      maxHeight: 260,
      panel: GestureDetector(
        onTap: _togglePanel,
        child: Container(
          decoration: BoxDecoration(),
          child: Column(
            children: <Widget>[
              //----------Button điều khiển------------------
              Container(
                height: 60,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //-------------Button Pause-------------
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isStarting
                              ? Colors.lightBlueAccent
                              : Colors.transparent),
                      child: IconButton(
                        onPressed: isStarting
                            ? () {
                                setState(() {
                                  isPausing = !isPausing;
                                });
                                if (isPausing == true) {
                                  time.pauseStopwatch();
                                  home.stopListeningStep();
                                } else {
                                  time.startStopwatch();
                                  home.startListeningStep();
                                }
                              }
                            : null,
                        icon: Icon(
                          isPausing ? Icons.play_arrow : Icons.pause,
                          color: isStarting ? Colors.white : Colors.transparent,
                        ),
                      ),
                    ),

                    //------------Button Start-----------------
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isStopping ? Colors.green : Colors.transparent),
                        child: IconButton(
                          onPressed: isStarting
                              ? null
                              : () {
                                  setState(() {
                                    isStarting = true;
                                    isStopping = false;
                                  });
                                  if (isStarting == true) {
                                    home.height = double.parse(userData.height);
                                    home.weight = double.parse(userData.weight);
                                    time.startStopwatch();
                                    home.dispose();
                                    home.getCurrentLocation(
                                        context: context, Case: 1);
                                    home.startListeningStep();
                                  }
                                },
                          icon: Icon(
                            Icons.play_arrow,
                            color:
                                isStarting ? Colors.transparent : Colors.white,
                          ),
                        ),
                      ),
                    ),

                    //--------------Button Stop-----------------
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isStarting ? Colors.red : Colors.transparent),
                      child: IconButton(
                        onPressed: isStarting
                            ? () {
                                setState(() {
                                  isStopping = true;
                                  isStarting = false;
                                });
                                time.pauseStopwatch();

                                print("ngoai" + home.latlngs.toString());

                                Map<String, dynamic> json = {
                                  "uid": userData.id,
                                  "step": home.stepCount,
                                  "distance": home.distance,
                                  "calo": home.caloriesBurned,
                                  "time": time.timeDisplay,
                                  "track": home.latlngs.toList(),
                                };

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Lưu hoạt động"),
                                        content: SingleChildScrollView(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: TextField(
                                                    controller:
                                                        descriptionTextController,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                      hintText: "Thêm mô tả",
                                                    ),
                                                    textInputAction:
                                                        TextInputAction.newline,
                                                    maxLines: 3,
                                                    minLines: 1,
                                                    maxLength: 50,
                                                  ),
                                                ),
                                                Container(
                                                    child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Khoảng cách"),
                                                            Text(
                                                                json["distance"]
                                                                    .toString())
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Bước chân"),
                                                            Text(json["step"]
                                                                .toString())
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Calo"),
                                                            Text(json["calo"]
                                                                .toString())
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Thời gian"),
                                                            Text(json["time"]
                                                                .toString()),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          FlatButton(
                                              onPressed: () {
                                                print("trong" +
                                                    json["track"].toString());
                                                Navigator.pop(context);
                                              },
                                              child: Text("HỦY")),
                                          FlatButton(
                                              onPressed: () {
                                                user.setDataCount(
                                                    json["uid"],
                                                    json["step"],
                                                    json["distance"],
                                                    json["calo"],
                                                    json["time"],
                                                    DateTime.now().toString(),
                                                    json["track"],
                                                    descriptionTextController
                                                        .text);
                                                Navigator.pop(context);
                                              },
                                              child: Text("LƯU"))
                                        ],
                                      );
                                    });

                                /*
                                user.setDataCount(
                                    userData.id,
                                    home.stepCount,
                                    home.distance,
                                    home.caloriesBurned,
                                    time.timeDisplay,
                                    DateTime.now().toString(),
                                    home.latlngs);

                                 */

                                time.resetStopwatch();
                                home.stopListeningStep();
                                home.resetStep();
                                home.dispose();
                              }
                            : null,
                        icon: Icon(
                          Icons.stop,
                          color: isStarting ? Colors.white : Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //-----------Count View-----------------------
              Container(padding: EdgeInsets.only(top: 20), child: CountView()),
            ],
          ),
        ),
      ),
    );
  }

  Future createPost(String idUser, String type, String description) async {
    DocumentReference docRef =
        await Firestore.instance.collection('posts').add({
      'uid': idUser,
      'type': type,
      'description': description,
    });
    Firestore.instance
        .collection('posts')
        .document(docRef.documentID)
        .updateData({'id': docRef.documentID});
  }
}
