import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vtb_device_info/models/device_info.dart';
import 'package:vtb_device_info/models/device_location.dart';

import 'vtb_device_info_method_channel.dart';

abstract class VtbDeviceInfoPlatform extends PlatformInterface {
  VtbDeviceInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static VtbDeviceInfoPlatform _instance = MethodChannelVtbDeviceInfo();

  static VtbDeviceInfoPlatform get instance => _instance;

  static set instance(VtbDeviceInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// DEVICE INFO
  Future<DeviceInfo?> getDeviceInfo() {
    throw UnimplementedError('getDeviceInfo() has not been implemented.');
  }

  /// INTERNET
  Future<bool> checkInternetConnected() {
    throw UnimplementedError('checkInternetConnected() has not been implemented.');
  }

  Stream<bool> get registerInternetStatusChange {
    throw UnimplementedError('registerInternetStatusChange() has not been implemented.');
  }

  /// BLUETOOTH
  Future<bool> checkBluetoothEnabled() {
    throw UnimplementedError('checkBluetoothEnabled() has not been implemented.');
  }

  Stream<bool> get registerBluetoothStatusChange {
    throw UnimplementedError('registerBluetoothStatusChange() has not been implemented.');
  }

  /// LOCATION
  Future<DeviceLocation?> getCurrentLocation() {
    throw UnimplementedError('getCurrentLocation() has not been implemented.');
  }

  Stream<DeviceLocation?> get registerDeviceLocationChange {
    throw UnimplementedError('registerDeviceLocationChange() has not been implemented.');
  }

  /// PERMISSIONS
  Future<bool> checkLocationPermissionGranted() {
    throw UnimplementedError('checkLocationPermissionGranted() has not been implemented.');
  }

  Future<bool> requestLocationPermission() {
    throw UnimplementedError('requestLocationPermission() has not been implemented.');
  }
}
