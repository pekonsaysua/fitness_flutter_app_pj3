import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/provider/home_provider.dart';

class TargetPage extends StatefulWidget {
  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _stepController = TextEditingController();
    final TextEditingController _distanceController = TextEditingController();
    final TextEditingController _timeController = TextEditingController();
    final TextEditingController _caloriesController = TextEditingController();
    final home = Provider.of<HomeProvider>(context);
    _stepController.text = home.stepTarget.toString();
    _distanceController.text = home.distanceTarget.toString();
    _timeController.text = home.timeTarget.toString();
    _caloriesController.text = home.caloriesTarget.toString();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.black54,
                  Colors.blue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: <Widget>[
                  //SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 480,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 210),
                          child: Text(
                            "Mục tiêu",
                            style: TextStyle(
                                color: Colors.white,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.remove),
                                    iconSize: 40,
                                    onPressed: (home.stepTarget < 1000)
                                        ? null
                                        : () {
                                            home.stepTarget -= 10;
                                            home.followStep(home.stepTarget);
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
                                                    home.stepTarget = int.parse(
                                                        _stepController.text);
                                                    home.followStep(
                                                        home.stepTarget);
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
                                                    _stepController.text = home
                                                        .stepTarget
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
                                          home.stepTarget.toString(),
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
                                      home.stepTarget += 10;
                                      home.followStep(home.stepTarget);
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
                                    home.distanceTarget -= 0.1;
                                    home.folowDistance(home.distanceTarget);
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
                                                  home.distanceTarget =
                                                      double.parse(
                                                          _distanceController
                                                              .text);
                                                  home.folowDistance(
                                                      home.distanceTarget);
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
                                                      home.distanceTarget
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        home.distanceTarget.toString() + " km",
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
                                    home.distanceTarget += 0.1;
                                    home.folowDistance(home.distanceTarget);
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.remove),
                                    iconSize: 40,
                                    onPressed: () {
                                      home.caloriesTarget -= 1;
                                      home.folowCalories(home.caloriesTarget);
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
                                                controller: _caloriesController,
                                              ),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                    home.caloriesTarget =
                                                        double.parse(
                                                            _caloriesController
                                                                .text);
                                                    home.folowCalories(
                                                        home.caloriesTarget);
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
                                                        home.caloriesTarget
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
                                          home.caloriesTarget.toString(),
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
                                      home.caloriesTarget += 1;
                                      home.folowCalories(home.caloriesTarget);
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
                                            home.timeTarget =
                                                int.parse(_timeController.text);
                                            Navigator.of(context).pop(context);
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
                                                home.timeTarget.toString();
                                            Navigator.of(context).pop(context);
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.remove),
                                    iconSize: 40,
                                    onPressed: () {
                                      home.timeTarget -= 1;
                                    }),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        home.timeTarget.toString(),
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
                                      home.timeTarget += 1;
                                    }),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //--------BUTTON SAVE--------------
                              SizedBox(
                                height: 50,
                                width: 140,
                                child: FloatingActionButton.extended(
                                  backgroundColor: Colors.green,
                                  label: Text(
                                    "LƯU",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {},
                                ),
                              ),

                              //---------BUTTON CANCEL------------
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  height: 50,
                                  width: 140,
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.red,
                                    label: Text(
                                      "HỦY",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
