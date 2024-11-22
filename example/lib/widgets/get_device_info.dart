import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/models/device_info.dart';
import 'package:vtb_device_info/vtb_device_info.dart';
import 'package:vtb_device_info_example/colors.dart';

class GetDeviceInfoWidget extends StatefulWidget {
  const GetDeviceInfoWidget({super.key});

  @override
  State<GetDeviceInfoWidget> createState() => _GetDeviceInfoWidgetState();
}

class _GetDeviceInfoWidgetState extends State<GetDeviceInfoWidget> {
  DeviceInfo? _deviceInfo;
  String? _statusMessage;

  Future<void> getDeviceInfo() async {
    setState(() {
      _deviceInfo = null;
      _statusMessage = 'Getting...';
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      _deviceInfo = await VtbDeviceInfo.instance.getDeviceInfo();
      _statusMessage = null;
    } on PlatformException {
      _statusMessage = 'Failed to get device info.';
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Get Device Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: VtbColors.vtbDartBlue),
            ),
            ElevatedButton(onPressed: getDeviceInfo, child: const Text('Get')),
          ],
        ),
        if (_statusMessage != null) Text(_statusMessage.toString()),
        if (_deviceInfo != null) Text(_deviceInfo.toString()),
      ],
    );
  }
}
