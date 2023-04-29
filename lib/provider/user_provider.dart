import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/config/initialization.dart';
import 'package:fitness_app/helpers/shared_preferrence.dart';
import 'package:fitness_app/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _user;

  FirebaseUser get user => _user;

  UserData _userData;

  UserData get userData => _userData;

  Status _status = Status.Uninitialized;

  set status(Status value) {
    _status = value;
  }

  Status get status => _status;

  bool get isMailExist => _isMailExist;

  set isMailExist(bool value) {
    _isMailExist = value;
  }

  bool _isMailExist = false;

  Firestore _firestore = Firestore.instance;

  //GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  GoogleSignInAccount account;

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  //--------------------Đăng Nhập-----------------------------
  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        String uid = user.user.uid;
        Firestore.instance
            .collection('users')
            .where("email", isEqualTo: email)
            .snapshots()
            .listen((data) => data.documents.forEach((doc) {
                  _userData = UserData.formSnapShot(doc);
                  UserData user = new UserData(
                    doc['uid'],
                    doc['name'],
                    doc['email'],
                    doc['phone'],
                    doc['pass'],
                    doc['weight'],
                    doc['height'],
                    doc['url_avt'],
                    doc['url_cover'],
                  );
                  StorageUtil.setUid(uid);
                  StorageUtil.setIsLogging(true);
                  StorageUtil.setUserInfo(user);
                  StorageUtil.setPassword(password);
                  notifyListeners();
                }));
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      //print(e.toString());
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _status = Status.Authenticating;
    notifyListeners();
    try {
      account = await googleSignIn.signIn();
      if (account == null) return false;
      await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.message);
      print("Error logging with google");
      return false;
    }
  }

  //-------------------Đăng Ký-------------------------------------
  Future<bool> signUp(String name, String email, String password, String phone,
      String weight, String height, String gender) async {
    try {
      print(email + "" + password);
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        _firestore.collection('users').document(user.user.uid).setData({
          'name': name,
          'email': email,
          'uid': user.user.uid,
          'phone': phone,
          'weight': weight,
          'height': height,
          'gender': gender
        });
      });
      print("thanh cong");
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  //-------------------Đăng Xuất--------------------
  Future signOut() async {
    _auth.signOut();

    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  //-------------------------Cập nhật dữ liệu-----------------

  //------Cập nhật thông tin cơ bản--------------------
  Future updateDataUser(String id, String name, String phone, String weight,
      String height) async {
    _firestore.collection('users').document(id).updateData(
        {'name': name, 'phone': phone, 'weight': weight, 'height': height});
    notifyListeners();
  }

  //------------Cập nhật Avatar-----------------
  Future updateAvt(String id, String urlAvt) async {
    _firestore.collection('users').document(id).updateData({
      'url_avt': urlAvt,
    });
    notifyListeners();
  }

  //---------------Cập nhật ảnh bìa---------------------
  Future updateCover(String id, String urlCover) async {
    _firestore.collection('users').document(id).updateData({
      'url_cover': urlCover,
    });
    notifyListeners();
  }

  //------------------------Tạo dữ liệu mới ----------------------
  Future setDataCount(
      String idUser,
      int step,
      double distance,
      double calories,
      String time,
      String date,
      List<LatLng> latlngs,
      String description) async {
    List<Map> convert = new List();
    for (var i in latlngs) convert.add({'lat': i.latitude, 'lng': i.longitude});
/*
    DocumentReference docRef = await _firestore.collection('activities').add({
      'uid': idUser,
      'step': step.toString(),
      'time': time,
      'distance': distance.toString(),
      'calories': calories.toString(),
      'date': date,
      'track': convert,
    });
    Firestore.instance
        .collection('activities')
        .document(docRef.documentID)
        .updateData({'id': docRef.documentID});


 */
    DocumentReference docRef2 =
        await Firestore.instance.collection('posts').add({
      'uid': idUser,
      //'actId': docRef.documentID,
      'type': 'run',
      'created': date,
      'description': description,
    });

    await _firestore
        .collection('posts')
        .document(docRef2.documentID)
        .updateData({
      'id': docRef2.documentID,
      "activity": {
        'step': step.toString(),
        'time': time,
        'distance': distance.toString(),
        'calories': calories.toString(),
        'date': date,
        'track': convert,
      }
    });
    notifyListeners();
  }

  Future createPost(String idUser, String type, String description) async {
    DocumentReference docRef =
        await Firestore.instance.collection('posts').add({
      'uid': idUser,
      'type': type,
      'description': description,
    });
    Firestore.instance
        .collection('posts')
        .document(docRef.documentID)
        .updateData({'id': docRef.documentID});
  }

  Future<void> _onStateChanged(FirebaseUser user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<void> setName(String name) {
    _userData.name = name;
    notifyListeners();
  }

  Future<void> setPhone(String phone) {
    _userData.phone = phone;
    notifyListeners();
  }

  Future<void> setHeight(String height) {
    _userData.height = height;
    notifyListeners();
  }

  Future<void> setWeight(String weight) {
    _userData.weight = weight;
    notifyListeners();
  }

  Future<void> setUrlAvt(String urlAvt) {
    _userData.urlAvt = urlAvt;
    notifyListeners();
  }

  Future<void> setUrlCover(String urlCover) {
    _userData.urlCover = urlCover;
    notifyListeners();
  }

  Future<void> checkMail(String mail) {
    Firestore.instance
        .collection('users')
        .where("email", isEqualTo: mail)
        .snapshots()
        .listen((data) {
      print(data.documents.isEmpty);
      if (data.documents.isEmpty) {
        _isMailExist = false;
        notifyListeners();
      } else {
        _isMailExist = true;
        notifyListeners();
      }
    });
  }
}
