import 'package:fitness_app/apis/api.dart';
import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/post.dart';
import 'package:fitness_app/widgets/MapWidget/image_map_widget.dart';
import 'package:fitness_app/widgets/Post/post_widget.dart';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  final String userId;

  const Activity({Key key, this.userId}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  List<PostModel> list = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      list = await init();
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<List<PostModel>> init() async {
    String myId = await StorageUtil.getUid();
    String id = widget.userId ?? myId;
    var innerList = await Api.getListPostApi(id);
    list = innerList;

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        list = await init();
      },
      child: isLoading
          ? Container(
              color: kColorWhite,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : StreamBuilder(
              initialData: list,
              stream: init().asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List snapList = snapshot.data;
                  if (snapList.isEmpty)
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
                                "Bạn chưa có hoạt động nào",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                  backgroundColor: kColorOrange,
                                  onPressed: () {
                                    Navigator.pushNamed(context, "home_screen");
                                  },
                                  child: Icon(Icons.add),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  else
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return PostWidget(list[index]);
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
