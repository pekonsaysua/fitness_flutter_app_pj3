import 'dart:convert';
import 'package:fitness_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  //TODO: SET UID
  static Future<void> setUid(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString('uid', value);
  }

  //TODO: GET UID
  static Future<String> getUid() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getString('uid');
  }

  //TODO: SET Full name
  static Future<void> setFullName(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString('fullname', value);
  }

  //TODO: GET Full name
  static Future<String> geFullName() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getString('fullname');
  }

  //TODO: SET password
  static Future<void> setPassword(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString('password', value);
  }

  //TODO: GET password
  static Future<String> getPassword() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getString('password');
  }

  //TODO: SET Is Logging
  static Future<void> setIsLogging(bool value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('isLogging', value);
  }

  //TODO: GET Is Logging
  static Future<bool> getIsLogging() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool('isLogging');
  }

  //TODO: Set User info
  static Future<void> setUserInfo(UserData user) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.setString('UserInfo', jsonEncode(user.toJson()));
  }

  //TODO: get User info
  static Future<UserData> getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> doc = jsonDecode(preferences.getString('UserInfo'));
    UserData user = new UserData(
      doc['uid'],
      doc['name'],
      doc['email'],
      doc['phone'],
      doc['pass'],
      doc['height'],
      doc['weight'],
      doc['url_avt'],
      doc['url_cover'],
    );
    UserData user1 =
        new UserData.fromJson(jsonDecode(preferences.getString('UserInfo')));
    return user;
  }

  //TODO: Clear Data
  static Future<void> clear() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.clear();
  }
}
