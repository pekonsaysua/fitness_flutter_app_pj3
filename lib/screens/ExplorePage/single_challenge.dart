import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/parse_date_helpers.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/challenge.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/ProfilePage/profile_page.dart';
import 'package:flutter/material.dart';

class SingleChallenge extends StatefulWidget {
  String challengeId;

  SingleChallenge(this.challengeId);

  @override
  _SingleChallengeState createState() => _SingleChallengeState();
}

class _SingleChallengeState extends State<SingleChallenge> {
  bool isLoading = true;

  ChallengeModel challenge;

  List<Map<String, dynamic>> list = new List();

  String myId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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
    myId = await StorageUtil.getUid();
    challenge = await Api.getChallengeApi(widget.challengeId);
    var doc = await Firestore.instance
        .collection("users_challenges")
        .where("challengeId", isEqualTo: widget.challengeId)
        .getDocuments();
    if (doc.documents.isNotEmpty) {
      for (var index in doc.documents) {
        Map<String, dynamic> json = index.data;

        UserData user = await Api.getUserApi(json["uid"]);
        Map<String, dynamic> stats = await Api.getStatsApi(
            json["uid"], ParseDate.getDay(json["created"]));
        list.add({"user": user.toJson(), "stats": stats});
      }
      list.sort((a, b) =>
          b["stats"]["distance"].toString().compareTo(a["stats"]["distance"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorOrange,
        title: Text("Thử thách"),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(challenge.name),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: challenge.isJoin
                            ? FlatButton(
                                onPressed: () {
                                  Api.setUnJoinChallenge(myId, challenge.id);
                                  setState(() {
                                    challenge.isJoin = false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: kColorOrange)),
                                child: Icon(
                                  Icons.done,
                                  color: kColorOrange,
                                ),
                              )
                            : FlatButton(
                                onPressed: () {
                                  Api.setJoinChallenge(myId, challenge.id);
                                  setState(() {
                                    challenge.isJoin = true;
                                  });
                                },
                                color: kColorOrange,
                                child: Text(
                                  "Tham gia",
                                  style: TextStyle(color: kColorWhite),
                                ),
                              ),
                      ),
                      ListTile(
                          leading: Icon(Icons.calendar_today_outlined),
                          title: Text(challenge.begin.split(" ").first +
                              " đến " +
                              challenge.end.split(" ").first)),
                      ListTile(
                        leading: Icon(Icons.directions_run_outlined),
                        title: RichText(
                          text: TextSpan(
                            text: "Hoàn thành",
                            children: [
                              if (challenge.target.step != null)
                                TextSpan(text: challenge.target.step + " bước"),
                              if (challenge.target.distance != null)
                                TextSpan(
                                    text: challenge.target.distance + " km"),
                              if (challenge.target.calo != null)
                                TextSpan(text: challenge.target.calo + " calo"),
                              if (challenge.target.time != null)
                                TextSpan(text: challenge.target.time),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.description),
                        title: Text(challenge.description ?? ""),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: Text("Xếp hạng")),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(flex: 3, child: Text("Tên")),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(flex: 2, child: Text("Quãng đường")),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length <= 10 ? list.length : 10,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> map = list[index];
                      print(map["user"]["uid"]);
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context).dividerColor))),
                        //padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          userId: map["user"]["uid"],
                                        )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 1, child: Text((index + 1).toString())),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 3, child: Text(map["user"]["name"])),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text(map["stats"]["distance"])),
                            ],
                          ),
                        ),
                      );
                      return ListTile(
                        leading: Text((index + 1).toString()),
                        title: Text(map["user"]["name"]),
                        trailing: Text(map["stats"]["distance"]),
                      );
                    }),
              ],
            ),
    );
  }
}
