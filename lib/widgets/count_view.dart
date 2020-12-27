import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/provider/home_provider.dart';
import 'package:fitness_app/provider/timer_provider.dart';

class CountView extends StatefulWidget {
  @override
  _CountViewState createState() => _CountViewState();
}

class _CountViewState extends State<CountView> {


  @override
  Widget build(BuildContext context) {
    final time = Provider.of<TimerProvider>(context);
    final home = Provider.of<HomeProvider>(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading:Icon(Icons.directions_walk, size: 30, color: Colors.white,),
                title: Text(home.stepCount.toString(), style: TextStyle(color: Colors.white, fontSize: 20),),
                subtitle: Text("Số bước",style: TextStyle(color: Colors.grey, fontSize: 13,fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                width: 150,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.red, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading:Icon(Icons.timer, size: 30, color: Colors.white,),
                  title: Text(time.timeDisplay.toString(), style: TextStyle(color: Colors.white, fontSize: 18),),
                  subtitle: Text("Thời gian",style: TextStyle(color: Colors.grey, fontSize: 13,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 23,),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.green, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Container(
                      width: 35,
                      height: 35,
                      child: Image.asset('assets/images/distance.png',fit: BoxFit.fill,)),
                  title: Text(home.distance.toString() + " km", style: TextStyle(color: Colors.white, fontSize: 18),),
                  subtitle: Text("Q.đường",style: TextStyle(color: Colors.grey, fontSize: 13,fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  width: 150,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.orange, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Container(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/images/burnedx.png',fit: BoxFit.fill,)),
                    title: Text(home.caloriesBurned.toString(), style: TextStyle(color: Colors.white, fontSize: 18),),
                    subtitle: Text("Calo",style: TextStyle(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
