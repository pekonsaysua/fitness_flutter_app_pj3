import 'package:flutter/material.dart';
import 'package:fitness_app/screens/Login/login_page.dart';
import 'package:fitness_app/screens/Register/register_page.dart';

import 'main_page.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[

          //------------Background Image----------------
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/background.jpg",
              fit: BoxFit.fill,
            ),
          ),

          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.blue,
                    Colors.orange.withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
            ),
            padding: EdgeInsets.fromLTRB(30, 200, 30, 0),
            child: ListView(
              children: <Widget>[

                //------------Logo------------------
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 100.0,
                    child: Image.asset(
                      "assets/images/icon.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),

                //-----------Name App----------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Center(
                      child: Text(
                    "RUN APP",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        inherit: false),
                  )),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Center(
                      child: Text(
                        "Phầm mềm hỗ trợ chạy bộ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            inherit: false),
                      )),
                ),

                //------------Button Đăng nhập-------------
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 52,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.blue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      borderRadius:  BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.orange,width: 2)
                    ),
                    child: RaisedButton(
                      color: Colors.black26,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                ),

                //------------Button Đăng ký----------------
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.blue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:  BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.red, width: 2)
                      ),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.black26,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
