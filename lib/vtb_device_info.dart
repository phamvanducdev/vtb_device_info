import 'package:vtb_device_info/models/device_info.dart';

import 'vtb_device_info_platform_interface.dart';

class VtbDeviceInfo {
  Future<DeviceInfo?> getDeviceInfo() {
    return VtbDeviceInfoPlatform.instance.getDeviceInfo();
  }

  Future<bool> isInternetConnected() {
    return VtbDeviceInfoPlatform.instance.isInternetConnected();
  }

  Future<bool> isBluetoothEnabled() {
    return VtbDeviceInfoPlatform.instance.isBluetoothEnabled();
  }

  Stream<bool> get registerInternetStatusChange {
    return VtbDeviceInfoPlatform.instance.registerInternetStatusChange;
  }

  Stream<bool> get registerBluetoothStatusChange {
    return VtbDeviceInfoPlatform.instance.registerBluetoothStatusChange;
  }
}
