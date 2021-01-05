import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TargetController extends GetxController {
  UserData user = UserData.empty();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await StorageUtil.getUserInfo();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  int _stepTarget = 1000;
  double _distanceTarget = 1;
  int _timeTarget = 30;
  double _caloriesTarget = 300;

  int get stepTarget => _stepTarget;

  set stepTarget(int value) {
    _stepTarget = value;
    update();
  }

  void followStep(int step, double _height, double _weight) {
    double stride = _height * 0.43;
    _distanceTarget = (step * stride) / 1000;
    _distanceTarget = num.parse(_distanceTarget.toStringAsFixed(4));
    update();
    _caloriesTarget = 0.5 * (_weight * 2.20462) * 1.60934 * _distanceTarget;
    _caloriesTarget = num.parse(_caloriesTarget.toStringAsFixed(4));
    update();
  }

  double get distanceTarget => _distanceTarget;

  set distanceTarget(double value) {
    _distanceTarget = value;
    update();
  }

  void folowDistance(double distances, double _height, double _weight) {
    double stride = _height * 0.43;
    _stepTarget = ((1000 * distances) / stride).round();

    update();

    _caloriesTarget = 0.5 * (_weight * 2.20462) * 1.60934 * distances;
    _caloriesTarget = num.parse(_caloriesTarget.toStringAsFixed(4));
    update();
  }

  int get timeTarget => _timeTarget;

  set timeTarget(int value) {
    _timeTarget = value;
    update();
  }

  double get caloriesTarget => _caloriesTarget;

  set caloriesTarget(double value) {
    _caloriesTarget = value;
    update();
  }

  void folowCalories(double calories, double _height, double _weight) {
    double stride = _height * 0.43;
    _distanceTarget = calories / (0.5 * (_weight * 2.20462) * 1.60934);
    _distanceTarget = num.parse(_distanceTarget.toStringAsFixed(4));
    update();
    _stepTarget = ((1000 * _distanceTarget) / stride).round();
    update();
  }
}
