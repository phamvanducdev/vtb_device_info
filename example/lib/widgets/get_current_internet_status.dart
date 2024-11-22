import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/vtb_device_info.dart';
import 'package:vtb_device_info_example/colors.dart';

class GetCurrentInternetStatusWidget extends StatefulWidget {
  const GetCurrentInternetStatusWidget({super.key});

  @override
  State<GetCurrentInternetStatusWidget> createState() => _GetCurrentInternetStatusWidgetState();
}

class _GetCurrentInternetStatusWidgetState extends State<GetCurrentInternetStatusWidget> {
  bool? _isConnected;
  String? _statusMessage;

  Future<void> getInternetConnected() async {
    setState(() {
      _isConnected = null;
      _statusMessage = 'Loading...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isConnected = await VtbDeviceInfo.instance.checkInternetConnected();
      _statusMessage = null;
    } on PlatformException {
      _statusMessage = 'Failed to get current internet status.';
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
              'Get Current Internet Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: VtbColors.vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: getInternetConnected,
              child: const Text('Get'),
            ),
          ],
        ),
        if (_statusMessage != null) Text(_statusMessage.toString()),
        if (_isConnected != null)
          Text(
            'Internet Connected: $_isConnected',
            style: TextStyle(color: _isConnected == true ? VtbColors.vtbLightBlue : VtbColors.vtbRed),
          ),
      ],
    );
  }
}
