import 'package:flutter/services.dart';
import 'package:vtb_device_info/models/device_info.dart';
import 'package:vtb_device_info/models/device_location.dart';

import 'vtb_device_info_platform_interface.dart';

class MethodChannelVtbDeviceInfo extends VtbDeviceInfoPlatform {
  final methodChannel = const MethodChannel('vtb_device_info');
  final internetEventChannel = const EventChannel('vtb_device_info/internet');
  final bluetoothEventChannel = const EventChannel('vtb_device_info/bluetooth');
  final deviceLocationEventChannel = const EventChannel('vtb_device_info/location');

  /// DEVICE_INFO
  @override
  Future<DeviceInfo?> getDeviceInfo() async {
    final result = await methodChannel.invokeMethod('getDeviceInfo');
    if (result == null) return null;
    try {
      return DeviceInfo.fromMap(result.cast<String, dynamic>());
    } catch (error) {
      return null;
    }
  }

  /// INTERNET
  @override
  Future<bool> checkInternetConnected() async {
    final result = await methodChannel.invokeMethod('checkInternetConnected');
    if (result is bool) return result;
    return false;
  }

  @override
  Stream<bool> get registerInternetStatusChange {
    return internetEventChannel.receiveBroadcastStream().map((event) => event == true);
  }

  /// BLUETOOTH
  @override
  Future<bool> checkBluetoothEnabled() async {
    final result = await methodChannel.invokeMethod('checkBluetoothEnabled');
    if (result is bool) return result;
    return false;
  }

  @override
  Stream<bool> get registerBluetoothStatusChange {
    return bluetoothEventChannel.receiveBroadcastStream().map((event) => event == true);
  }

  /// LOCATION
  @override
  Future<DeviceLocation?> getCurrentLocation() async {
    final result = await methodChannel.invokeMethod('getCurrentLocation');
    if (result == null) return null;
    try {
      return DeviceLocation.fromMap(result.cast<String, dynamic>());
    } catch (error) {
      return null;
    }
  }

  @override
  Stream<DeviceLocation?> get registerDeviceLocationChange {
    return deviceLocationEventChannel
        .receiveBroadcastStream()
        .map((event) => DeviceLocation.fromMap(event.cast<String, dynamic>()));
  }

  /// PERMISSION
  @override
  Future<bool> checkLocationPermissionGranted() async {
    final result = await methodChannel.invokeMethod('checkLocationPermissionGranted');
    if (result is bool) return result;
    return false;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final result = await methodChannel.invokeMethod('requestLocationPermission');
    if (result is bool) return result;
    return false;
  }
}
