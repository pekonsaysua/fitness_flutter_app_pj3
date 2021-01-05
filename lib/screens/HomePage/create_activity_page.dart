import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:flutter/material.dart';

class SaveActivity extends StatefulWidget {
  @override
  _SaveActivityState createState() => _SaveActivityState();
}

class _SaveActivityState extends State<SaveActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorOrange,
        title: Text("Luu hoat dong"),
        actions: [
          FlatButton(onPressed: () {}, child: Text("Luu")),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(

        ),
      ),
    );
  }
}
