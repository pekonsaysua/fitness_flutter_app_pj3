import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/provider/home_provider.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(20.858661, 105.917510),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height-120,
      child: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            polylines: home.polylines,
            initialCameraPosition: initialLocation,
            markers: Set.of((home.marker != null) ? [home.marker] : []),
            onMapCreated: (GoogleMapController controller) {
              home.controller = controller;
            },
          ),
          Container(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
                child: Icon(Icons.location_searching),
                onPressed: () {
                  home.getCurrentLocation(context: context, Case: 2);
                }),
          ),
        ],
      ),
    );
  }
}
