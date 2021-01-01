import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullViewMap extends StatefulWidget {
  List<LatLng> latlngs;

  FullViewMap(this.latlngs);

  @override
  _FullViewMapState createState() => _FullViewMapState();
}

class _FullViewMapState extends State<FullViewMap> {
  Controller _controller = Get.put(Controller());

  GoogleMapController gController;
  Set<Marker> markers;
  Set<Polyline> polylines;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers = {
      Marker(markerId: MarkerId("begin"), position: widget.latlngs.first),
      Marker(markerId: MarkerId("end"), position: widget.latlngs.last),
    };

    polylines = {
      Polyline(
        polylineId: PolylineId("poly"),
        visible: true,
        width: 5,
        points: widget.latlngs,
        color: Colors.red,
      )
    };
  }

  LatLng averageScreen() {
    double aveLat = 0, aveLng = 0;
    int len = widget.latlngs.length;
    for (var i in widget.latlngs) {
      aveLat = aveLat + i.latitude / len;
      aveLng = aveLng + i.longitude / len;
    }
    return new LatLng(aveLat, aveLng);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<Controller>(
          init: _controller,
          builder: (controller) {
            var mapType;
            controller._isChoose == MapTypeChanged.Standard
                ? mapType = MapType.normal
                : controller._isChoose == MapTypeChanged.Hybrid
                    ? mapType = MapType.hybrid
                    : mapType = MapType.satellite;
            return GoogleMap(
              myLocationButtonEnabled: false,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              myLocationEnabled: false,
              //zoomControlsEnabled: true,
              mapType: mapType,
              compassEnabled: false,
              polylines: polylines,
              initialCameraPosition: CameraPosition(
                target: averageScreen(),
                zoom: 15,
              ),
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                gController = controller;
              },
              onTap: (point) {
                print(point);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorWhite,
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              enableDrag: true,
              isDismissible: true,
              useRootNavigator: true,
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Text("Map Settings"),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        GetBuilder<Controller>(
                          init: _controller,
                          builder: (controller) => Container(
                            child: Column(
                              children: [
                                LabeledRadio(
                                  label: 'Standard',
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  value: MapTypeChanged.Standard,
                                  groupValue: controller._isChoose,
                                  onChanged: (MapTypeChanged newValue) {
                                    controller.onChanged(newValue);
                                  },
                                ),
                                LabeledRadio(
                                  label: 'Satellite',
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  value: MapTypeChanged.Satellite,
                                  groupValue: controller._isChoose,
                                  onChanged: (MapTypeChanged newValue) {
                                    controller.onChanged(newValue);
                                  },
                                ),
                                LabeledRadio(
                                  label: 'Hybrid',
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  value: MapTypeChanged.Hybrid,
                                  groupValue: controller._isChoose,
                                  onChanged: (MapTypeChanged newValue) {
                                    controller.onChanged(newValue);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.map_outlined, color: kColorBlack),
      ),
    );
  }
}

enum MapTypeChanged { Standard, Satellite, Hybrid }

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final groupValue;
  final value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (value != groupValue) onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label),
            Radio<MapTypeChanged>(
              groupValue: groupValue,
              value: value,
              onChanged: (MapTypeChanged newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Controller extends GetxController {
  MapTypeChanged _isChoose = MapTypeChanged.Standard;

  void onChanged(var newValue) {
    //printInfo(info: "fasm");
    _isChoose = newValue;
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _isChoose = MapTypeChanged.Standard;
    super.onClose();
  }
}
