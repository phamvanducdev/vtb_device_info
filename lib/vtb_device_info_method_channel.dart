import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/models/device_info.dart';

import 'vtb_device_info_platform_interface.dart';

class MethodChannelVtbDeviceInfo extends VtbDeviceInfoPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('vtb_device_info');
  final internetEventChannel = const EventChannel('vtb_device_info/internet_status');
  final bluetoothEventChannel = const EventChannel('vtb_device_info/bluetooth_status');

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

  @override
  Future<bool> isInternetConnected() async {
    final result = await methodChannel.invokeMethod('isInternetConnected');
    if (result is bool) return result;
    return false;
  }

  @override
  Future<bool> isBluetoothEnabled() async {
    final result = await methodChannel.invokeMethod('isBluetoothEnabled');
    if (result is bool) return result;
    return false;
  }

  @override
  Stream<bool> get registerInternetStatusChange {
    return internetEventChannel.receiveBroadcastStream().map((event) => event == true);
  }

  @override
  Stream<bool> get registerBluetoothStatusChange {
    return bluetoothEventChannel.receiveBroadcastStream().map((event) => event == true);
  }
}
