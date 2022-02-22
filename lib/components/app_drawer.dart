import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_mobile/main.dart';
import 'package:tracking_mobile/models/user.dart';
import 'package:tracking_mobile/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
    required this.user,
    required this.prefs,
  }) : super(key: key);

  final User? user;
  final SharedPreferences? prefs;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(user!.name),
              accountEmail: const SizedBox.shrink(),
              currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white)),
          ListTile(
            title: const Text("Logout"),
            onTap: () {
              prefs?.clear();
              Navigator.of(navigatorKey.currentContext!).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
    );
  }
}
