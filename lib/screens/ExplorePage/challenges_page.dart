import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChallengesPage extends StatefulWidget {
  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  GoogleMapController gController;

  List<LatLng> latlngs = [
    LatLng(20.859349416752657, 105.9138310700655),
    LatLng(20.856336055255806, 105.91493412852287),
    LatLng(20.856530305790265, 105.92111427336931),
    LatLng(20.860254228004628, 105.91987576335669),
    LatLng(20.860700992217296, 105.91609921306372)
  ];
  Set<Marker> markers;
  Set<Polyline> polylines;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers = {
      Marker(markerId: MarkerId("begin"), position: latlngs.first),
      Marker(markerId: MarkerId("end"), position: latlngs.last),
    };

    polylines = {
      Polyline(
        polylineId: PolylineId("poly"),
        visible: true,
        width: 5,
        points: latlngs,
        color: Colors.red,
      )
    };
  }

  List<MapType> a = [MapType.normal, MapType.hybrid, MapType.satellite];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 120,
      child: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.satellite,
            compassEnabled: false,
            polylines: polylines,
            initialCameraPosition: CameraPosition(
              target: LatLng(20.858661, 105.917510),
              zoom: 15,
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              gController = controller;
            },
            onTap: (point) {
              print(point);
              print(latlngs.length);
              setState(() {
                latlngs.add(point);
                markers.add(
                    new Marker(markerId: MarkerId("home"), position: point));
                polylines.add(Polyline(
                  polylineId: PolylineId("poly"),
                  visible: true,
                  width: 5,
                  points: latlngs,
                  color: Colors.red,
                ));
              });
            },
          ),
          Container(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
                child: Icon(Icons.location_searching),
                onPressed: () {
                  //home.getCurrentLocation(context: context, Case: 2);
                }),
          ),
        ],
      ),
    );
  }
}
