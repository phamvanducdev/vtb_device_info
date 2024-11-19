import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/models/device_info.dart';
import 'package:vtb_device_info/vtb_device_info.dart';

void main() {
  runApp(const VtbDeviceInfoApp());
}

class VtbDeviceInfoApp extends StatefulWidget {
  const VtbDeviceInfoApp({super.key});

  @override
  State<VtbDeviceInfoApp> createState() => _VtbDeviceInfoAppState();
}

class _VtbDeviceInfoAppState extends State<VtbDeviceInfoApp> {
  final _vtbDeviceInfo = VtbDeviceInfo();

  DeviceInfo? _deviceInfo;
  String? _deviceInfoError;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getDeviceInfo() async {
    try {
      _deviceInfo = await _vtbDeviceInfo.getDeviceInfo();
    } on PlatformException {
      _deviceInfoError = 'Failed to get device info.';
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color vietinRed = Color.fromRGBO(215, 18, 73, 1);
    const Color vietinDartBlue = Color.fromRGBO(0, 89, 147, 1);
    const Color vietinLightBlue = Color.fromRGBO(126, 211, 247, 1);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vtb Device Info', style: TextStyle(color: vietinRed)),
          backgroundColor: vietinLightBlue,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _deviceInfo != null
                  ? _deviceInfoError != null
                      ? Text(_deviceInfoError.toString())
                      : const SizedBox()
                  : ElevatedButton(
                      onPressed: getDeviceInfo,
                      child: const Text('Get Device Info'),
                    ),
              if (_deviceInfo != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device ID    : ${_deviceInfo?.deviceId}'),
                    Text('Device Name  : ${_deviceInfo?.deviceName}'),
                    Text('Device Model : ${_deviceInfo?.deviceModel}'),
                    Text('OS Name      : ${_deviceInfo?.systemName}'),
                    Text('OS Version   : ${_deviceInfo?.systemVersion}'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
