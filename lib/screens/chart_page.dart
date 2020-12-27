import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/chart_view.dart';
class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black54,
              Colors.blue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //ChartView(),
        ],
      ),
    );
  }
}

