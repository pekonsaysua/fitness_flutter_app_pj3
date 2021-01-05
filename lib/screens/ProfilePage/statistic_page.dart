import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/parse_date_helpers.dart';
import 'package:fitness_app/models/data_count.dart';
import 'package:fitness_app/screens/ProfilePage/edit_profile_page.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  String userId;

  StatisticPage(this.userId);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  bool isLoading = true;

  Map<String, dynamic> statsAll = new Map();
  Map<String, dynamic> statsWeek = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });

      await init();

      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> init() async {
    var doc = await Firestore.instance
        .collection("posts")
        .where("uid", isEqualTo: widget.userId)
        .getDocuments();
    List<DataCount> listAll = new List();
    List<DataCount> listWeek = new List();

    for (var i in doc.documents) {
      Map<String, dynamic> json = i.data;
      DataCount dataCount = DataCount.fromJson(json["activity"]);
      listAll.add(dataCount);
      if (ParseDate.getDay(dataCount.date) <= 7) listWeek.add(dataCount);
    }
    statsAll = getStats(listAll);
    statsWeek = getStats(listWeek);
  }

  Map<String, dynamic> getStats(List<DataCount> list) {
    var distance = 0.0;
    var calo = 0.0;
    var step = 0;
    var second = 0;
    var minute = 0;
    var hour = 0;
    var time = "00:00";
    for (var dataCount in list) {
      distance = distance + double.parse(dataCount.distance);
      calo = calo + double.parse(dataCount.calories);
      step = step + int.parse(dataCount.step);
      var a = dataCount.time.split(":");
      second = second + int.parse(a.last);
      minute = minute + int.parse(a.first);
    }
    if ((second - second % 60) != 0) minute = minute + 1;
    if ((minute - minute % 60) != 0) hour = hour + 1;
    second = second % 60;
    time = (hour == 0 ? "" : hour.toString() + "h") +
        (minute == 0 ? "" : minute.toString() + "m") +
        second.toString() +
        "s";
    return {
      "count": list.length.toString(),
      "distance": distance.toString(),
      "calo": calo.toString(),
      "step": step.toString(),
      "time": time
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorOrange,
        title: Text("Thống kê"),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  StatisticCard(
                    title: "Tất cả",
                    run: statsAll["count"],
                    distance: statsAll["distance"],
                    calories: statsAll["calo"],
                    step: statsAll["step"],
                    time: statsAll["time"],
                  ),
                  StatisticCard(
                    title: "Tuần này",
                    run: statsWeek["count"],
                    distance: statsWeek["distance"],
                    calories: statsWeek["calo"],
                    step: statsWeek["step"],
                    time: statsWeek["time"],
                  ),
                  StatisticCard(
                    title: "Trung bình",
                    distance: (double.parse(statsWeek["distance"]) / 7)
                        .toStringAsFixed(5),
                    calories: (double.parse(statsWeek["calo"]) / 7)
                        .toStringAsFixed(5),
                  ),
                ],
              ),
            ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String run;
  final String time;
  final String distance;
  final String step;
  final String calories;

  const StatisticCard(
      {Key key,
      this.title,
      this.run,
      this.time,
      this.distance,
      this.step,
      this.calories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerLeft,
          height: 40,
          color: Colors.grey[200],
          child: Text(title),
        ),
        if (run != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            leading: Text("Số lần chạy"),
            trailing: Text(run),
          ),
        if (time != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            leading: Text("Thời gian"),
            trailing: Text(time),
          ),
        if (distance != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            leading: Text("Quãng đường"),
            trailing: Text(distance + " km"),
          ),
        if (step != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            leading: Text("Số bước"),
            trailing: Text(step + " bước"),
          ),
        if (calories != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            leading: Text("Số calo tiêu thụ"),
            trailing: Text(calories + " calo"),
          ),
      ],
    );
  }
}
