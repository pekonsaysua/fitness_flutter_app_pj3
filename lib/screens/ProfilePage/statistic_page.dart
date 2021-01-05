import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/apis/api.dart';
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
    statsAll = await Api.getStatsApi(widget.userId);
    statsWeek = await Api.getStatsApi(widget.userId, 7);
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
