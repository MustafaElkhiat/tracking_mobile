//import 'package:geocode/geocode.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as LocationLibrary;
import 'package:tracking_mobile/models/Location.dart' as MyLocationLibrary;

class LocationDetails {
  getLocation() async {
    LocationLibrary.Location location = LocationLibrary.Location();

    bool _serviceEnabled;
    LocationLibrary.PermissionStatus _permissionGranted;
    LocationLibrary.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == LocationLibrary.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != LocationLibrary.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<LocationLibrary.LocationData> getCurrentLocation() async {
    LocationLibrary.LocationData locationData = await getLocation();
    return locationData;
  }

  Future<Location> getCoordinates({required String address}) async {
    List<Location> locations = await locationFromAddress(address);
    return locations.first;
  }

  Future<String> getAddress(
      {required double latitude, required double longitude}) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark address = placemarks.first;
    return "country : ${address.country} , name : ${address.name} , street : ${address.street} , subAdmin : ${address.subAdministrativeArea} ,admin : ${address.administrativeArea},countryCode : ${address.isoCountryCode}, locality : ${address.locality} , postalCode : ${address.postalCode}, subLocality : ${address.subLocality}, subThFare : ${address.subThoroughfare}, thFare : ${address.thoroughfare}";
  }

  Future<String> loadLocationsFromAssets() async {
    return await rootBundle.loadString('assets/json/locations.json');
  }
/*  Future<Coordinates> getCoordinates() async {
    GeoCode geoCode = GeoCode();
    Coordinates coordinates = await geoCode.forwardGeocoding(
        address: "532 S Olive St, Los Angeles, CA 90013");
    return coordinates;
  }

  Future<String> getAddress({double? latitude, double? longitude}) async {
    if (latitude == null || longitude == null) return "";
    GeoCode geoCode = GeoCode();
    Address address = await geoCode.reverseGeocoding(
        latitude: latitude, longitude: longitude);
    print("address:${address.countryName}");
    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }*/
}
