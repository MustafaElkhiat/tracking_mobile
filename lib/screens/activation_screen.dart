import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tracking_mobile/components/app_button.dart';
import 'package:tracking_mobile/constants.dart';
import 'package:tracking_mobile/main.dart';
import 'package:tracking_mobile/models/user.dart';
import 'package:tracking_mobile/screens/followers_tracking_screen.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({Key? key}) : super(key: key);

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  bool _passwordVisible = false, _confirmVisible = false;
  String password = "";
  String confirm = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    //SharedPreferences.getInstance().then((value) => prefs = value);
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
                        "Activation",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: Text(
                        "Create your password",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        "to activate your account",
                        style: TextStyle(fontSize: 20),
                      ),
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
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black45),
                          errorStyle: const TextStyle(color: Colors.redAccent),
                          border: const OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmVisible = !_confirmVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_confirmVisible,
                        onChanged: (String value) {
                          setState(() {
                            confirm = value;
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
                          if (val != password) {
                            return 'Not Match';
                          }
                          return null;
                        }),
                  ),
                  AppButton(
                      label: "Activate",
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        var user = User.fromJson(
                            jsonDecode((prefs?.getString("user"))!.toString()));
                        var data = {"user": user, "password": password};
                        print("data:" + data.toString());
                        var url =
                            Uri.parse('http://${ip}:${port}/api/user/activate');
                        var response = await client!.put(url,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode(data));
                        User updatedUser =
                            User.fromJson(jsonDecode(response.body));
                        /*String user =
                            jsonDecode(response.body)['user'].toString();*/
                        await prefs?.setString("user", jsonEncode(updatedUser));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FollowersTrackingScreen()),
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
