import 'package:flutter/material.dart';
import 'package:tracking_mobile/models/Location.dart';

class DropdownLocation extends StatefulWidget {
  final List<LocationData> locations;
  final ValueChanged<LocationData?>? onChanged;
  final LocationData? selectedLocation;
  const DropdownLocation(
      {Key? key,
      required this.locations,
      this.onChanged,
      this.selectedLocation})
      : super(key: key);

  @override
  State createState() => DropdownLocationState();
}

class DropdownLocationState extends State<DropdownLocation> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<LocationData>(
      hint: const Text("Select Location"),
      value: widget.selectedLocation,
      onChanged: widget.onChanged,
      items: widget.locations.map((LocationData location) {
        return DropdownMenuItem<LocationData>(
          value: location,
          child: Text(
            location.location,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
