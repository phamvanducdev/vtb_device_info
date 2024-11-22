import 'package:vtb_device_info/models/device_info.dart';
import 'package:vtb_device_info/models/device_location.dart';

import 'vtb_device_info_platform_interface.dart';

class VtbDeviceInfo {
  VtbDeviceInfo._();

  static VtbDeviceInfo instance = VtbDeviceInfo._();

  /// DEVICE_INFO
  Future<DeviceInfo?> getDeviceInfo() {
    return VtbDeviceInfoPlatform.instance.getDeviceInfo();
  }

  /// INTERNET
  Future<bool> checkInternetConnected() {
    return VtbDeviceInfoPlatform.instance.checkInternetConnected();
  }

  Stream<bool> get registerInternetStatusChange {
    return VtbDeviceInfoPlatform.instance.registerInternetStatusChange;
  }

  /// BLUETOOTH

  Future<bool> checkBluetoothEnabled() {
    return VtbDeviceInfoPlatform.instance.checkBluetoothEnabled();
  }

  Stream<bool> get registerBluetoothStatusChange {
    return VtbDeviceInfoPlatform.instance.registerBluetoothStatusChange;
  }

  /// LOCATION
  Future<DeviceLocation?> getCurrentLocation() {
    return VtbDeviceInfoPlatform.instance.getCurrentLocation();
  }

  Stream<DeviceLocation?> get registerDeviceLocationChange {
    return VtbDeviceInfoPlatform.instance.registerDeviceLocationChange;
  }

  /// PERMISSIONS
  Future<bool> checkLocationPermissionGranted() {
    return VtbDeviceInfoPlatform.instance.checkLocationPermissionGranted();
  }

  Future<bool> requestLocationPermission() {
    return VtbDeviceInfoPlatform.instance.requestLocationPermission();
  }
}
