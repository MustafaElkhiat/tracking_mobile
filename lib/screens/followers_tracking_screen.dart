import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_mobile/components/app_drawer.dart';
import 'package:tracking_mobile/constants.dart';
import 'package:tracking_mobile/follower_tracking.dart';
import 'package:tracking_mobile/main.dart';
import 'package:tracking_mobile/models/user.dart';
import 'package:tracking_mobile/models/user_movement.dart';
import 'package:tracking_mobile/screens/add_location_screen.dart';
import 'package:tracking_mobile/screens/login_screen.dart';

class FollowersTrackingScreen extends StatefulWidget {
  const FollowersTrackingScreen({Key? key}) : super(key: key);

  @override
  State<FollowersTrackingScreen> createState() =>
      _FollowersTrackingScreenState();
}

class _FollowersTrackingScreenState extends State<FollowersTrackingScreen> {
  bool loading = true;
  SharedPreferences? prefs;
  User? user;
  List<UserMovement> followerTrackingData = [];

  Future<void> initializePreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      setState(() {
        user =
            User.fromJson(jsonDecode((prefs?.getString("user"))!.toString()));
      });
      getData();
    });
  }

  void getData() async {
    setState(() {
      loading = true;
    });
    Uri url;
    if (user?.authorities[0]['authority'] == 'FOLLOWER_ROLE') {
      url = Uri.parse('http://${ip}:${port}/api/user/lastMoveOfUser?username=' +
          user!.username);
    } else /*if (user?.authorities[0]['authority'] == 'LEADER_ROLE')*/ {
      url = Uri.parse(
          'http://${ip}:${port}/api/user/lastMoveOfFollowersOfLeader?username=' +
              user!.username);
    }

    var response = await client!.get(
        url /*, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + (prefs?.getString("access_token"))!
    }*/
        );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        loading = false;
        followerTrackingData = data
            .map((userMovement) => UserMovement.fromJson(userMovement))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(user?.authorities);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(user: user, prefs: prefs),
        appBar: buildAppBar(_scaffoldKey),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: followerTrackingData.length,
                itemBuilder: (context, index) {
                  return FollowerTracking(
                    name: followerTrackingData[index].user.name,
                    location: followerTrackingData[index].location.location,
                    to: followerTrackingData[index].to,
                    from: followerTrackingData[index].from,
                  );
                })
        /*ListView(
              children: const [
                FollowerTracking(
                    name: "Mustafa Mohammed",
                    location: "Alexandria",
                    from: "10-02-2022",
                    to: "10-02-2022"),
                FollowerTracking(
                    name: "Mohammed Mustafa",
                    location: "Cairo",
                    from: "10-02-2022",
                    to: "11-02-2022")
              ],
            ),*/
        );
  }

  AppBar buildAppBar(GlobalKey<ScaffoldState> _scaffoldKey) {
    return AppBar(
      title: const Text("Tracking Details"),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(Icons.menu),
      ),
      actions: [
        user?.authorities[0]['authority'] == 'FOLLOWER_ROLE'
            ? IconButton(
                onPressed: () {
                  Navigator.of(navigatorKey.currentContext!).push(
                      MaterialPageRoute(
                          builder: (context) => const AddLocationScreen()));
                },
                icon: const Icon(Icons.add_location))
            : const SizedBox.shrink(),
        IconButton(onPressed: () => getData(), icon: const Icon(Icons.refresh))
      ],
    );
  }
}
