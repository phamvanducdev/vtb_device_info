import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vtb_device_info/models/device_info.dart';
import 'package:vtb_device_info/vtb_device_info_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelVtbDeviceInfo platform = MethodChannelVtbDeviceInfo();
  const MethodChannel channel = MethodChannel('vtb_device_info');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return {'systemVersion': '14'};
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getDeviceInfo', () async {
    DeviceInfo? deviceInfo = await platform.getDeviceInfo();
    expect(deviceInfo?.systemVersion, '14');
  });
}
