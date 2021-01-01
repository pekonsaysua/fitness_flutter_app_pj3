import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';


class HomeProvider with ChangeNotifier {

  Location _locationTracker = Location();
  LocationData _locationData;
  GoogleMapController _controller;
  set controller(GoogleMapController value) {
    _controller = value;
    notifyListeners();
  }

  List<LatLng> latlngs = []; //mảng lưu vị trí
  LocationData get locationData => _locationData;
  // ignore: sdk_version_set_literal
  Set<Polyline> polylines = {};
  Marker marker;
  BuildContext _context;
  double _height;
  double _weight;

  //Step Provider
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  int _stepCountCurrent = 0;
  int _stepCount = 0;
  double _distance = 0;

  set height(double value) {
    _height = value;
  }

  double get height => _height;
  double _caloriesBurned = 0;
  double get caloriesBurned => _caloriesBurned;

  //-------------------- Map Provider-----------------------
  //-------------Cập nhật lại Map khi có sự thay đổi vị trí -----------------
  void updateMap(LocationData newLocalData, BuildContext context) async {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);

    print(latlng.toString());

    marker = Marker(
        markerId: MarkerId("home"),
        position: latlng,
        rotation: newLocalData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: await BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(context), 'assets/pngwave.png'));
    notifyListeners();

    if (latlngs.length >= 2) {
      polylines.add(Polyline(
        polylineId: PolylineId("poly"),
        visible: true,
        width: 5,
        points: latlngs,
        color: Colors.red,
      ));
      notifyListeners();
    }
  }

  //----------Lấy vị trí hiện tại của thiết bị---------------
  void getCurrentLocation({BuildContext context, int Case}) async {
    if (context != null) {
      _context = context;
    }
    try {
      var location = await _locationTracker.getLocation();
      if (Case == 1) {
        latlngs.add(LatLng(location.latitude, location.longitude));
      }
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 0,
              target: LatLng(location.latitude, location.longitude),
              tilt: 0,
              zoom: 19.00)));

      if (context == null)
        updateMap(location, _context);
      else
        updateMap(location, context);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void dispose() {
    polylines.clear();
    latlngs.clear();
    notifyListeners();
  }

  // Step Provider
  double get distance => _distance;

  //-----------Tạo sự kiện lắng nghe bước chân-----------------
  void startListeningStep() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void stopListeningStep() {
    _subscription.pause();
  }

  void _onData(int stepCountValue) async {
    int preStep;
    preStep = _stepCountCurrent;
    if (preStep == 0) {
      _stepCountCurrent = stepCountValue;
    }
    if (preStep != 0 && stepCountValue > preStep) {
      _stepCount++;
      _stepCountCurrent = stepCountValue;
      notifyListeners();
      if ((_stepCount % 5) == 0 && _stepCount > 0) {
        getCurrentLocation(Case: 1);
        notifyListeners();
      }
    }
    _countDistance(_stepCount);
  }

  int get stepCount => _stepCount;
  void resetStep() {
    _stepCount = 0;
    _stepCountCurrent = 0;
    _caloriesBurned = 0;
    _distance = 0;
    notifyListeners();
  }
  void _onDone() {}
  void _onError(error) => print("Flutter Pedometer Error: $error");

  //-------------Tính quãng đường---------------------
  void _countDistance(int step) {
    double stride = _height * 0.43;
    _distance = (step * stride) / 1000;
    _distance = num.parse(_distance.toStringAsFixed(4));
    notifyListeners();
    _countCalories(_distance);
  }


  //--------------Tính lượng kalo được đốt cháy-------------------
  void _countCalories(double distance) {
    _caloriesBurned = 0.5 * (_weight * 2.20462) * 1.60934 * distance;
    _caloriesBurned = num.parse(_caloriesBurned.toStringAsFixed(4));
    notifyListeners();
  }

  set weight(double value) {
    _weight = value;
  }

  int _stepTarget = 1000;
  double _distanceTarget = 1;
  int _timeTarget = 30;
  double _caloriesTarget = 300;


  int get stepTarget => _stepTarget;

  set stepTarget(int value) {
    _stepTarget = value;
    notifyListeners();

  }
void followStep(int step){
  double stride = _height * 0.43;
  _distanceTarget = (step * stride) / 1000;
  _distanceTarget = num.parse(_distanceTarget.toStringAsFixed(4));
  notifyListeners();
  _caloriesTarget = 0.5 * (_weight * 2.20462) * 1.60934 * _distanceTarget;
  _caloriesTarget = num.parse(_caloriesTarget.toStringAsFixed(4));
  notifyListeners();
}
  double get distanceTarget => _distanceTarget;

  set distanceTarget(double value) {
    _distanceTarget = value;
    notifyListeners();
  }
  void folowDistance(double distances){
    double stride = _height * 0.43;
    _stepTarget = ((1000*distances)/stride).round();
    notifyListeners();
    _caloriesTarget = 0.5 * (_weight * 2.20462) * 1.60934 * distances;
    _caloriesTarget = num.parse(_caloriesTarget.toStringAsFixed(4));
    notifyListeners();
  }
  int get timeTarget => _timeTarget;

  set timeTarget(int value) {
    _timeTarget = value;
    notifyListeners();
  }

  double get caloriesTarget => _caloriesTarget;

  set caloriesTarget(double value) {
    _caloriesTarget = value;
    notifyListeners();
  }
  void folowCalories(double calories){
    double stride = _height * 0.43;
    _distanceTarget = calories/(0.5 * (_weight * 2.20462) * 1.60934);
    _distanceTarget = num.parse(_distanceTarget.toStringAsFixed(4));
    notifyListeners();
    _stepTarget = ((1000*_distanceTarget)/stride).round();
    notifyListeners();
  }
}
