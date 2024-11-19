import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vtb_device_info/models/device_info.dart';

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

  Future<DeviceInfo?> getDeviceInfo() {
    throw UnimplementedError('deviceInfo() has not been implemented.');
  }
}