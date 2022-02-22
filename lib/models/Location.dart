class LocationData {
  final String location;
  final String latitude;
  final String longitude;

  const LocationData(this.location, this.latitude, this.longitude);

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(json['location'], json['latitude'], json['longitude']);
  }

  Map<String, dynamic> toJson() =>
      {'location': location, 'latitude': latitude, 'longitude': longitude};
}

class Location {
  final String label;
  final LocationData value;

  const Location(this.label, this.value);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(json['label'], LocationData.fromJson(json['value']));
  }

  Map<String, dynamic> toJson() => {'label': label, 'value': value};
}
