class DeviceInfo {
  final String deviceId;
  final String deviceName;
  final String deviceModel;
  final String systemName;
  final String systemVersion;

  DeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.deviceModel,
    required this.systemName,
    required this.systemVersion,
  });

  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      deviceId: map['deviceId'] ?? 'Unknown',
      deviceName: map['deviceName'] ?? 'Unknown',
      deviceModel: map['deviceModel'] ?? 'Unknown',
      systemName: map['systemName'] ?? 'Unknown',
      systemVersion: map['systemVersion'] ?? 'Unknown',
    );
  }

  @override
  String toString() {
    return 'DeviceInfo(deviceId: $deviceId, deviceName: $deviceName, deviceModel: $deviceModel, systemName: $systemName, systemVersion: $systemVersion)';
  }
}
