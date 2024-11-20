import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vtb_device_info/models/device_info.dart';
import 'package:vtb_device_info/vtb_device_info_platform_interface.dart';

class MockVtbDeviceInfoPlatform with MockPlatformInterfaceMixin implements VtbDeviceInfoPlatform {
  @override
  Future<DeviceInfo?> getDeviceInfo() {
    // TODO: implement getDeviceInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> isInternetConnected() {
    // TODO: implement isInternetConnected
    throw UnimplementedError();
  }

  @override
  Future<bool> isBluetoothEnabled() {
    // TODO: implement isBluetoothEnabled
    throw UnimplementedError();
  }

  @override
  // TODO: implement registerInternetStatusChange
  Stream<bool> get registerInternetStatusChange => throw UnimplementedError();

  @override
  // TODO: implement registerBluetoothStatusChange
  Stream<bool> get registerBluetoothStatusChange => throw UnimplementedError();
}

void main() {
  // final VtbDeviceInfoPlatform initialPlatform = VtbDeviceInfoPlatform.instance;

  // test('$MethodChannelVtbDeviceInfo is the default instance', () {
  //   expect(initialPlatform, isInstanceOf<MethodChannelVtbDeviceInfo>());
  // });

  // test('getDeviceInfo', () async {
  //   VtbDeviceInfo vtbDeviceInfoPlugin = VtbDeviceInfo();
  //   MockVtbDeviceInfoPlatform fakePlatform = MockVtbDeviceInfoPlatform();
  //   VtbDeviceInfoPlatform.instance = fakePlatform;
  //   DeviceInfo? deviceInfo = await vtbDeviceInfoPlugin.getDeviceInfo();
  //   expect(deviceInfo?.systemVersion, '14');
  // });
}
