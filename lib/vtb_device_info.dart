import 'package:vtb_device_info/models/device_info.dart';

import 'vtb_device_info_platform_interface.dart';

class VtbDeviceInfo {
  Future<DeviceInfo?> getDeviceInfo() {
    return VtbDeviceInfoPlatform.instance.getDeviceInfo();
  }
}
