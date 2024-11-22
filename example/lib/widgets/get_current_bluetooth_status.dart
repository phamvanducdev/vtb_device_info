import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/vtb_device_info.dart';
import 'package:vtb_device_info_example/colors.dart';

class GetCurrentBluetoothStatusWidget extends StatefulWidget {
  const GetCurrentBluetoothStatusWidget({super.key});

  @override
  State<GetCurrentBluetoothStatusWidget> createState() => _GetCurrentBluetoothStatusWidgetState();
}

class _GetCurrentBluetoothStatusWidgetState extends State<GetCurrentBluetoothStatusWidget> {
  bool? _isEnabled;
  String? _statusMessage;

  Future<void> getBluetoothStatus() async {
    setState(() {
      _isEnabled = null;
      _statusMessage = 'Loading...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isEnabled = await VtbDeviceInfo.instance.checkBluetoothEnabled();
      _statusMessage = null;
    } on PlatformException {
      _statusMessage = 'Failed to get current bluetooth status.';
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
              'Get Current Bluetooth Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: VtbColors.vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: getBluetoothStatus,
              child: const Text('Get'),
            ),
          ],
        ),
        if (_statusMessage != null) Text(_statusMessage.toString()),
        if (_isEnabled != null)
          Text(
            'Bluetooth Enabled: $_isEnabled',
            style: TextStyle(color: _isEnabled == true ? VtbColors.vtbLightBlue : VtbColors.vtbRed),
          ),
      ],
    );
  }
}
