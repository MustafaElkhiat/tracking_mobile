import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_mobile/http/http_interceptor.dart';
import 'package:tracking_mobile/models/user.dart';
import 'package:tracking_mobile/screens/followers_tracking_screen.dart';
import 'package:tracking_mobile/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  loggedIn =
      (prefs?.getBool("loggedIn") == null) ? false : prefs?.getBool("loggedIn");
  user = User.fromJson(jsonDecode((prefs?.getString("user"))!));
  runApp(const MyApp());
}

SharedPreferences? prefs;
bool? loggedIn = false;
User? user;
Client? client;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    client = InterceptedClient.build(interceptors: [
      HttpInterceptor(context: context),
    ], retryPolicy: ExpiredTokenRetryPolicy());
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: loggedIn! && user!.activated
            ? const FollowersTrackingScreen()
            : const LoginScreen());
    //home: const AddLocationScreen());
    //home: const FollowersTrackingScreen());
  }
}
