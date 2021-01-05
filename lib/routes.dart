import 'package:fitness_app/screens/HomePage/home_page.dart';
import 'package:fitness_app/screens/ProfilePage/edit_profile_page.dart';
import 'package:fitness_app/screens/ProfilePage/setting_page.dart';
import 'package:fitness_app/screens/intro_page.dart';
import 'package:fitness_app/screens/Login/login_page.dart';
import 'package:fitness_app/screens/main_page.dart';
import 'package:fitness_app/screens/ProfilePage/profile_page.dart';
import 'package:fitness_app/screens/Register/register_coun_page.dart';
import 'package:fitness_app/screens/Register/register_page.dart';
import 'package:fitness_app/screens/MenuPage/target_page.dart';
import 'package:fitness_app/splash_screen.dart';

const initialRoute = "splash_screen";

var routes = {
  'splash_screen': (context) => SplashScreen(),
  'intro_screen': (context) => IntroPage(),
  //REGISTER
  'signup_screen': (context) => RegisterPage(),
  //'signup_step1': (context) => RegisterPageCoun(),
  //LOGIN
  'login_screen': (context) => LoginPage(),
  //HOME VIEW
  //'home_screen2': (context) => HomeScreen(),

  'home_screen': (context) => HomePage(),
  //CREATE POST
  'main_screen': (context) => MainPage(),
  // PROFILE
  //'profile_screen': (context) => ProfilePage(),
  'edit_profile_screen': (context) => EditProfile(),
  'target_screen': (context) => TargetPage(),
  'setting_screen': (context) => SettingPage(),
};
