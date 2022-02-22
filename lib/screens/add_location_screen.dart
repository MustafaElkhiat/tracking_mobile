import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:tracking_mobile/LocationDetails.dart';
import 'package:tracking_mobile/components/app_button.dart';
import 'package:tracking_mobile/components/app_drawer.dart';
import 'package:tracking_mobile/constants.dart';
import 'package:tracking_mobile/main.dart';
import 'package:tracking_mobile/models/Location.dart' as MyLocationLibrary;
import 'package:tracking_mobile/models/user.dart';
import 'package:tracking_mobile/screens/followers_tracking_screen.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({Key? key}) : super(key: key);

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  late double latitude = 26.8357675, longitude = 30.7956597;
  late String location = "", locationsString = "", to = "", from = "";
  final List<Map<String, dynamic>> _items = [
    {
      "label": "Cairo",
      "value": 1,
      "latitude": 30.033333,
      "longitude": 31.233334
    },
    {
      "label": "Alexandria",
      "value": 2,
      "latitude": 31.21564,
      "longitude": 29.95527
    },
    {
      "label": "Damietta",
      "value": 3,
      "latitude": 31.41648,
      "longitude": 31.81332
    },
    {"label": "Suez", "value": 4, "latitude": 29.97371, "longitude": 32.52627},
    {
      "label": "PortSaid",
      "value": 5,
      "latitude": 31.25654,
      "longitude": 32.28411
    }
  ];
  User? user;
  List<MyLocationLibrary.Location> locationList = [];
  MyLocationLibrary.LocationData? selectedLocation;
  SnackBar snackBar = const SnackBar(
    content: Text('Your Location has been added'),
  );
  @override
  void initState() {
    super.initState();
    /*LocationDetails().loadLocationsFromAssets().then((value) => setState(() {
          locationList = jsonDecode(value) as List<MyLocationLibrary.Location>;
          locationList
              .map((location) => {
                    _items.add(<String, dynamic>{
                      'label': location.label,
                      'value': location.value
                    })
                  })
              .toList();
        }));*/
    user = User.fromJson(jsonDecode((prefs?.getString("user"))!.toString()));
    LocationDetails().getCurrentLocation().then((currentLocation) =>
        setState(() {
          latitude = currentLocation.latitude!;
          longitude = currentLocation.longitude!;
          LocationDetails()
              .getAddress(latitude: latitude, longitude: longitude)
              .then((addressValue) => setState(() => location = addressValue));
        }));
    /*LocationDetails()
        .getCoordinates(address: "Alexandria")
        .then((coordinate) => setState(() {
              latitude = coordinate.latitude;
              longitude = coordinate.longitude;
            }));*/
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    /*List list = jsonDecode(locationsString);
    List<Map<String, dynamic>> locations =
        list.map((location) => location as Map<String, dynamic>).toList();*/

    //List<Map<String,dynamic>> locations = list.map((location) => MyLocationLibrary.Location.fromJson(location)).to
    // List of items in our dropdown menu

    return Scaffold(
      drawer: AppDrawer(user: user, prefs: prefs),
      appBar: AppBar(
        title: const Text("Add Location"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FollowersTrackingScreen()),
                );
              },
              icon: const Icon(Icons.home)),
        ],
        /*leading: IconButton(
          onPressed: () {
            //Scaffold.of(context).openDrawer();
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),*/
      ),
      body: FlutterMap(
        nonRotatedChildren: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
                      child: SelectFormField(
                        type: SelectFormFieldType.dropdown,
                        // or can be dialog
                        hintText: 'Select Location',
                        labelText: 'Location',
                        items: _items,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          labelText: 'Location',
                        ),
                        onChanged: (val) {
                          setState(() {
                            latitude = _items[int.parse(val) - 1]['latitude'];
                            longitude = _items[int.parse(val) - 1]['longitude'];
                            location = _items[int.parse(val) - 1]['label'];
                          });
                        },
                        onSaved: (val) => print(val),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: screenWidth / 2,
                          child: DateTimeFormField(
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black45),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              labelText: 'From',
                            ),
                            dateFormat: DateFormat('dd-MM-yyyy'),
                            mode: DateTimeFieldPickerMode.date,
                            autovalidateMode: AutovalidateMode.always,
                            /*validator: (e) => (e?.day ?? 0) == 1
                                ? 'Please not the first day'
                                : null,*/
                            onDateSelected: (DateTime value) {
                              setState(() {
                                from = DateFormat('dd-MM-yyyy').format(value);
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: screenWidth / 2,
                          child: DateTimeFormField(
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black45),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              labelText: 'To',
                            ),
                            dateFormat: DateFormat('dd-MM-yyyy'),
                            mode: DateTimeFieldPickerMode.date,
                            autovalidateMode: AutovalidateMode.always,
                            /*validator: (e) => (e?.day ?? 0) == 1
                                ? 'Please not the first day'
                                : null,*/
                            onDateSelected: (DateTime value) {
                              setState(() {
                                to = DateFormat('dd-MM-yyyy').format(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    AppButton(
                        label: "Save",
                        onPressed: () async {
                          var url = Uri.parse(
                              'http://${ip}:${port}/api/user/userMovement');
                          print(url);
                          var data = {
                            "from": from,
                            "to": to,
                            "location": {
                              "location": location,
                              "latitude": latitude,
                              "longitude": longitude
                            },
                            "user": user
                          };
                          var response = await client!.post(url,
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode(data));
                          print(response.statusCode);
                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        width: screenWidth,
                        height: 45)
                  ],
                ),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
              ),
            ],
          ),
        ],
        options: MapOptions(
          rotation: 0,
          center: LatLng(latitude, longitude),
          zoom: 5.5,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            /*attributionBuilder: (_) {
              return Text("© OpenStreetMap contributors");
            },*/
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(latitude, longitude),
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
