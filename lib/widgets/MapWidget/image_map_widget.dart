import 'package:fitness_app/widgets/MapWidget/fullview_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ImageMap extends StatelessWidget {
  List<LatLng> latlngs;
  ImageMap(this.latlngs);

  @override
  Widget build(BuildContext context) {
    Set<Polyline> polylines = {
      Polyline(
        polylineId: PolylineId("poly"),
        visible: true,
        width: 5,
        points: latlngs,
        color: Colors.red,
      )
    };
    double aveLat=0, aveLng=0;
    int len = latlngs.length;
    for(var i in latlngs){
      aveLat = aveLat + i.latitude/len;
      aveLng = aveLng + i.longitude/len;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.3,
      child: GoogleMap(
        myLocationButtonEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
        tiltGesturesEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        compassEnabled: false,
        polylines: polylines,
        initialCameraPosition: CameraPosition(
          target: LatLng(aveLat, aveLng),
          zoom: 16,
        ),
        onTap: (point) {
          print(point);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullViewMap(latlngs),
            ),
          );
        },
      ),
    );
  }
}
