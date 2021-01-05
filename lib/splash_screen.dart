import 'package:flutter/material.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    delay().then((viewLink) {
      Navigator.pushNamedAndRemoveUntil(context, viewLink, (route) => false);
    });
  }

  Future<String> delay() async {
    String viewLink = 'intro_screen';
    StorageUtil.getIsLogging().then((result) async {
      if (result == null || result == false) {
        viewLink = 'intro_screen';
      } else {
        viewLink = 'main_screen';
      }
    });
    await Future.delayed(Duration(seconds: 3));
    return viewLink;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.contain,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
