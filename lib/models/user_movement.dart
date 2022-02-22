import 'package:tracking_mobile/models/Location.dart';
import 'package:tracking_mobile/models/user.dart';

class UserMovement {
  final String id;
  final String from;
  final String to;
  final LocationData location;
  final User user;

  UserMovement(this.id, this.from, this.to, this.location, this.user);

  factory UserMovement.fromJson(Map<String, dynamic> json) {
    return UserMovement(json['id'], json['from'], json['to'],
        LocationData.fromJson(json['location']), User.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'from': from, 'to': to, 'location': location, 'user': user};
}
