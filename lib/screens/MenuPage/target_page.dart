import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/MenuPage/target_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/provider/home_provider.dart';

class TargetPage extends StatefulWidget {
  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  UserData user = UserData.empty();

  TargetController targetController = Get.put(TargetController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await StorageUtil.getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _stepController = TextEditingController();
    final TextEditingController _distanceController = TextEditingController();
    final TextEditingController _timeController = TextEditingController();
    final TextEditingController _caloriesController = TextEditingController();

    final home = Provider.of<HomeProvider>(context);

    _stepController.text = targetController.stepTarget.toString();
    _distanceController.text = targetController.distanceTarget.toString();
    _timeController.text = targetController.timeTarget.toString();
    _caloriesController.text = targetController.caloriesTarget.toString();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kColorOrange,
        title: Text("Menu"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: <Widget>[
                  //SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 440,
                    width: MediaQuery.of(context).size.width,
                    child: GetBuilder<TargetController>(
                        builder: (targetController) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 210),
                            child: Text(
                              "Mục tiêu",
                              style: TextStyle(
                                  color: kColorOrange,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          //-----------Step target--------------------
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                            child: Container(
                              height: 70,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.remove),
                                      iconSize: 40,
                                      onPressed: (targetController.stepTarget <
                                              1000)
                                          ? null
                                          : () {
                                              targetController.stepTarget -= 10;
                                              targetController.followStep(
                                                  targetController.stepTarget,
                                                  double.parse(user.height),
                                                  double.parse(user.weight));
                                            }),
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Số bước"),
                                                content: TextField(
                                                  controller: _stepController,
                                                ),
                                                actions: <Widget>[
                                                  MaterialButton(
                                                    onPressed: () {
                                                      targetController
                                                              .stepTarget =
                                                          int.parse(
                                                              _stepController
                                                                  .text);
                                                      targetController
                                                          .followStep(
                                                              targetController
                                                                  .stepTarget,
                                                              double.parse(
                                                                  user.height),
                                                              double.parse(
                                                                  user.weight));
                                                      Navigator.of(context)
                                                          .pop(context);
                                                    },
                                                    child: Text(
                                                      "Lưu",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      _stepController.text =
                                                          home.stepTarget
                                                              .toString();
                                                      Navigator.of(context)
                                                          .pop(context);
                                                    },
                                                    child: Text(
                                                      "Thoát",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            targetController.stepTarget
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Số bước",
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 40,
                                      onPressed: () {
                                        targetController.stepTarget += 10;
                                        targetController.followStep(
                                            targetController.stepTarget,
                                            double.parse(user.height),
                                            double.parse(user.weight));
                                      }),
                                ],
                              ),
                            ),
                          ),

                          //-----------Distance target--------------------
                          Container(
                            height: 70,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.remove),
                                    iconSize: 40,
                                    onPressed: () {
                                      targetController.distanceTarget -= 0.1;
                                      targetController.folowDistance(
                                          targetController.distanceTarget,
                                          double.parse(user.height),
                                          double.parse(user.weight));
                                    }),
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Quãng đường"),
                                              content: TextField(
                                                controller: _distanceController,
                                              ),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                    targetController
                                                            .distanceTarget =
                                                        double.parse(
                                                            _distanceController
                                                                .text);
                                                    targetController
                                                        .folowDistance(
                                                            targetController
                                                                .distanceTarget,
                                                            double.parse(
                                                                user.height),
                                                            double.parse(
                                                                user.weight));
                                                    Navigator.of(context)
                                                        .pop(context);
                                                  },
                                                  child: Text(
                                                    "Lưu",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    _distanceController.text =
                                                        targetController
                                                            .distanceTarget
                                                            .toString();
                                                    Navigator.of(context)
                                                        .pop(context);
                                                  },
                                                  child: Text(
                                                    "Thoát",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          targetController.distanceTarget
                                                  .toString() +
                                              " km",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Quãng đường",
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.add),
                                    iconSize: 40,
                                    onPressed: () {
                                      targetController.distanceTarget += 0.1;
                                      targetController.folowDistance(
                                          targetController.distanceTarget,
                                          double.parse(user.height),
                                          double.parse(user.weight));
                                    }),
                              ],
                            ),
                          ),

                          //------------- Calories Target---------------
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Container(
                              height: 70,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.remove),
                                      iconSize: 40,
                                      onPressed: () {
                                        targetController.caloriesTarget -= 1;
                                        targetController.folowCalories(
                                            targetController.caloriesTarget,
                                            double.parse(user.height),
                                            double.parse(user.weight));
                                      }),
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Calo"),
                                                content: TextField(
                                                  controller:
                                                      _caloriesController,
                                                ),
                                                actions: <Widget>[
                                                  MaterialButton(
                                                    onPressed: () {
                                                      targetController
                                                              .caloriesTarget =
                                                          double.parse(
                                                              _caloriesController
                                                                  .text);
                                                      targetController
                                                          .folowCalories(
                                                              targetController
                                                                  .caloriesTarget,
                                                              double.parse(
                                                                  user.height),
                                                              double.parse(
                                                                  user.weight));
                                                      Navigator.of(context)
                                                          .pop(context);
                                                    },
                                                    child: Text(
                                                      "Lưu",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      _caloriesController.text =
                                                          targetController
                                                              .caloriesTarget
                                                              .toString();
                                                      Navigator.of(context)
                                                          .pop(context);
                                                    },
                                                    child: Text(
                                                      "Thoát",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            targetController.caloriesTarget
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "calo",
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 40,
                                      onPressed: () {
                                        targetController.caloriesTarget += 1;
                                        targetController.folowCalories(
                                            targetController.caloriesTarget,
                                            double.parse(user.height),
                                            double.parse(user.weight));
                                      }),
                                ],
                              ),
                            ),
                          ),

                          //------------- Time Target---------------
                          Container(
                            height: 70,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Thời gian (phút)"),
                                        content: TextField(
                                          controller: _timeController,
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              targetController.timeTarget =
                                                  int.parse(
                                                      _timeController.text);
                                              Navigator.of(context)
                                                  .pop(context);
                                            },
                                            child: Text(
                                              "Lưu",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              _timeController.text =
                                                  targetController.timeTarget
                                                      .toString();
                                              Navigator.of(context)
                                                  .pop(context);
                                            },
                                            child: Text(
                                              "Thoát",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.remove),
                                      iconSize: 40,
                                      onPressed: () {
                                        targetController.timeTarget -= 1;
                                      }),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          targetController.timeTarget
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Thời gian",
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 40,
                                      onPressed: () {
                                        targetController.timeTarget += 1;
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                      color: kColorOrange.withOpacity(0.3),
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      child: ListTile(
                        leading: Icon(Icons.close),
                        title: Text("Thoát ứng dụng"),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
