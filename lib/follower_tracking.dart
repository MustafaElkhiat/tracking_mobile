import 'package:flutter/material.dart';

class FollowerTracking extends StatelessWidget {
  final String name;
  final String location;
  final String from;
  final String to;

  const FollowerTracking(
      {Key? key,
      required this.name,
      required this.location,
      required this.from,
      required this.to})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            location,
            style: const TextStyle(color: Colors.black54),
          ),
          Text(
            'From : ' + from,
            style: const TextStyle(color: Colors.black45, fontSize: 12),
          ),
          Text(
            'To : ' + to,
            style: const TextStyle(color: Colors.black45, fontSize: 12),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
