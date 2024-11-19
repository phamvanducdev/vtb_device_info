import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/models/device_info.dart';

import 'vtb_device_info_platform_interface.dart';

class MethodChannelVtbDeviceInfo extends VtbDeviceInfoPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('vtb_device_info');

  @override
  Future<DeviceInfo?> getDeviceInfo() async {
    final result = await methodChannel.invokeMethod('getDeviceInfo');
    if (result == null) return null;
    return DeviceInfo.fromMap(result.cast<String, dynamic>());
  }
}
