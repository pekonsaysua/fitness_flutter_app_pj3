import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cai dat"),
        backgroundColor: kColorOrange,
      ),
      body: ListView(
        children: [
          FlatButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: CircularProgressIndicator(),
                      );
                    });
                await signOut();
                await StorageUtil.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, 'intro_screen', (route) => false);
              },
              child: Container(
                child: Text("Đăng xuất"),
              ))
        ],
      ),
    );
  }
}
