import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/provider/chart_provider.dart';
import 'package:fitness_app/provider/home_provider.dart';
import 'package:fitness_app/provider/timer_provider.dart';
import 'package:fitness_app/provider/user_provider.dart';
import 'package:fitness_app/routes.dart';
import 'package:fitness_app/screens/HomePage/home_page.dart';
import 'package:fitness_app/screens/intro_page.dart';
import 'package:fitness_app/screens/Login/login_page.dart';
import 'package:fitness_app/screens/main_page.dart';
import 'package:fitness_app/screens/ProfilePage/profile_page.dart';
//import 'package:fitness_app/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize()),
    ChangeNotifierProvider.value(value: TimerProvider()),
    ChangeNotifierProvider.value(value: HomeProvider()),
    ChangeNotifierProvider.value(value: ChartProvider()),
  ], child: MyApp()));

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
