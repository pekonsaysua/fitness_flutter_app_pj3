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
