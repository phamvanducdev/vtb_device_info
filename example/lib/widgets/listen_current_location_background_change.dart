import 'package:flutter/material.dart';
import 'package:vtb_device_info/models/device_location.dart';
import 'package:vtb_device_info/vtb_device_info.dart';
import 'package:vtb_device_info_example/colors.dart';

class ListentCurrentLocationBackgroundChangeWidget extends StatefulWidget {
  const ListentCurrentLocationBackgroundChangeWidget({super.key});

  @override
  State<ListentCurrentLocationBackgroundChangeWidget> createState() => _ListentCurrentLocationBackgroundChangeWidgetState();
}

class _ListentCurrentLocationBackgroundChangeWidgetState extends State<ListentCurrentLocationBackgroundChangeWidget> {
  Stream<DeviceLocation?>? _deviceLocationStream;
  String? _statusMessage;

  Future<void> onRegister() async {
    setState(() {
      _deviceLocationStream = null;
      _statusMessage = 'Registering...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _deviceLocationStream = VtbDeviceInfo.instance.registerDeviceLocationBackgroundChange;
      _statusMessage = 'Listening...';
    } on Exception {
      _statusMessage = 'Failed to register device location.';
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // onRegister();
  }

  @override
  void dispose() {
    _deviceLocationStream = null;
    super.dispose();
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
              'Listen Location Background Change',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: VtbColors.vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: onRegister,
              child: const Text('Register'),
            ),
          ],
        ),
        if (_statusMessage != null) Text(_statusMessage.toString()),
        if (_deviceLocationStream != null)
          StreamBuilder<DeviceLocation?>(
            stream: _deviceLocationStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: VtbColors.vtbRed),
                );
              }
              final deviceLocation = snapshot.data;
              return Text(
                deviceLocation.toString(),
                style: const TextStyle(color: VtbColors.vtbDartBlue),
              );
            },
          ),
      ],
    );
  }
}
