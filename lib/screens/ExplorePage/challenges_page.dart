import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/challenge.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/screens/ExplorePage/single_challenge.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChallengesPage extends StatefulWidget {
  final String userId;

  const ChallengesPage({Key key, this.userId}) : super(key: key);

  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with AutomaticKeepAliveClientMixin {
  List<ChallengeModel> list = List();
  bool isLoading = true;
  String myId = "";
  bool checkJoin = false;

  String uid = "";

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

  Future<List<ChallengeModel>> init() async {
    myId = await StorageUtil.getUid();
    bool a = widget.userId != null;
    uid = widget.userId ?? myId;
    list = await Api.getListChallengeApi(uid, a);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await init();
      },
      child: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : StreamBuilder(
              initialData: list,
              stream: init().asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data;
                  if (list.isEmpty)
                    return ListView(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 50),
                          color: kColorWhite,
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/emptyInbox.png",
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                "Không có thử thách phù hợp cho bạn",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text("Vui lòng quay trở lại sau"),
                            ],
                          ),
                        ),
                      ],
                    );
                  else
                    return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          var chal = list[index];
                          return Container(
                            color: kColorWhite,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SingleChallenge(chal.id)));
                                  },
                                  leading: Icon(Icons.local_activity_outlined),
                                  title: Text(chal.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (chal.target.step != null)
                                        Text(chal.target.step),
                                      if (chal.target.distance != null)
                                        Text(chal.target.distance),
                                      if (chal.target.calo != null)
                                        Text(chal.target.calo),
                                      if (chal.target.time != null)
                                        Text(chal.target.time),
                                      Text(chal.begin.split(" ").first +
                                          " to " +
                                          chal.end.split(" ").first)
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: chal.isJoin
                                      ? FlatButton(
                                          onPressed: () {
                                            Api.setUnJoinChallenge(
                                                uid, chal.id);
                                            setState(() {
                                              chal.isJoin = false;
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: kColorOrange)),
                                          child: Icon(
                                            Icons.done,
                                            color: kColorOrange,
                                          ),
                                        )
                                      : FlatButton(
                                          onPressed: () {
                                            Api.setJoinChallenge(uid, chal.id);
                                            setState(() {
                                              chal.isJoin = true;
                                            });
                                          },
                                          color: kColorOrange,
                                          child: Text(
                                            "Tham gia",
                                            style:
                                                TextStyle(color: kColorWhite),
                                          ),
                                        ),
                                )
                              ],
                            ),
                          );
                        });
                } else
                  return Text("Loi");
              }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
