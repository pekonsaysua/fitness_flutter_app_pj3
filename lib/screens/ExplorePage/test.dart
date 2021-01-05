

/*

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


import 'package:fitness_app/helpers/colors_constant.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ClubPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  String imageUrl;

  MapBoxStaticImage staticImage = MapBoxStaticImage(
    apiKey:
    'pk.eyJ1IjoiYXNocmFmaWowMDciLCJhIjoiY2s2Nm40ZjFkMDAxMDNubXo3M3V4Y2pvaiJ9.cQACwGfCXD1iuKdJeZDozA',
  );
  //var a = MapboxMap();

  Future<String> getStaticImageWithMarker() async {
    String temp;
    try {
      temp = staticImage.getStaticUrlWithPolyline(
          point1: Location(lat: 37.77343, lng: -122.46589),
          point2: Location(lat: 37.75965, lng: -122.42816),
          marker1: MapBoxMarker(
              markerColor: Colors.black,
              markerLetter: 'p',
              markerSize: MarkerSize.LARGE),
          msrker2: MapBoxMarker(
              markerColor: kColorRed,
              markerLetter: 'q',
              markerSize: MarkerSize.SMALL),
          height: 300,
          width: 600,
          zoomLevel: 50,
          style: MapBoxStyle.Mapbox_Dark,
          path: MapBoxPath(
              pathColor: Colors.red,
              pathOpacity: 0.5,
              pathWidth: 5,
              pathPolyline: "abc"),
          render2x: true);
    } catch (e) {
      print("a");
      print(e.toString());
    }
    setState(() {
      print(temp);
      imageUrl = temp;
    });
    return temp;
    return staticImage.getStaticUrlWithMarker(
      center: Location(lat: 37.77343, lng: -122.46589),
      marker: MapBoxMarker(
          markerColor: kColorRed,
          markerLetter: 'p',
          markerSize: MarkerSize.LARGE),
      height: 300,
      width: 600,
      zoomLevel: 16,
      style: MapBoxStyle.Mapbox_Streets,
      render2x: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    getStaticImageWithMarker();
    return imageUrl == null ? Container() : Image.network(imageUrl);
  }
}


 */