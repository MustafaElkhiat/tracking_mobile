import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_mobile/components/app_button.dart';
import 'package:tracking_mobile/constants.dart';
import 'package:tracking_mobile/models/user.dart';
import 'package:tracking_mobile/screens/activation_screen.dart';
import 'package:tracking_mobile/screens/followers_tracking_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  String username = "";
  String password = "";
  SharedPreferences? prefs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          username = value;
                        });
                      },
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black45),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordVisible,
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  AppButton(
                      label: "Login",
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        var url = Uri.parse('http://${ip}:${port}/login');
                        var data = {"username": username, "password": password};
                        var response = await http.post(url,
                            headers: {"Content-Type": "application/json"},
                            body: jsonEncode(data));

                        User user =
                            User.fromJson(jsonDecode(response.body)['user']);
                        /*String user =
                            jsonDecode(response.body)['user'].toString();*/
                        await prefs?.setString("user", jsonEncode(user));
                        await prefs?.setBool("loggedIn", true);
                        await prefs?.setString(
                            "access_token",
                            jsonDecode(response.body)['access_token']
                                .toString());
                        await prefs?.setString(
                            "refresh_token",
                            jsonDecode(response.body)['refresh_token']
                                .toString());
                        Widget goTo;
                        if (user.activated) {
                          goTo = const FollowersTrackingScreen();
                        } else {
                          goTo = const ActivationScreen();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => goTo),
                        );
                      },
                      width: screenWidth,
                      height: 45)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
