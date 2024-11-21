import 'dart:convert';

class DeviceLocation {
  final double latitude;
  final double longitude;

  DeviceLocation({
    required this.latitude,
    required this.longitude,
  });

  factory DeviceLocation.fromMap(Map<String, dynamic> map) {
    return DeviceLocation(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() => const JsonEncoder.withIndent('    ').convert(toJson());
}
