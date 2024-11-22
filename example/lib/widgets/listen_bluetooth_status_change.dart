import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/vtb_device_info.dart';
import 'package:vtb_device_info_example/colors.dart';

class ListenBluetoothStatusChangeWidget extends StatefulWidget {
  const ListenBluetoothStatusChangeWidget({super.key});

  @override
  State<ListenBluetoothStatusChangeWidget> createState() => _ListenBluetoothStatusChangeWidgetState();
}

class _ListenBluetoothStatusChangeWidgetState extends State<ListenBluetoothStatusChangeWidget> {
  Stream<bool>? _isStatusStream;
  String? _statusMessage;

  Future<void> onRegister() async {
    setState(() {
      _isStatusStream = null;
      _statusMessage = 'Registering...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isStatusStream = VtbDeviceInfo.instance.registerBluetoothStatusChange;
      _statusMessage = 'Listening...';
    } on PlatformException {
      _statusMessage = 'Failed to register bluetooth status change.';
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
    _isStatusStream = null;
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
              'Listen Bluetooth Status Change',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: VtbColors.vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: onRegister,
              child: const Text('Register'),
            ),
          ],
        ),
        if (_statusMessage != null) Text(_statusMessage.toString()),
        if (_isStatusStream != null)
          StreamBuilder<bool>(
            stream: _isStatusStream,
            builder: (context, snapshot) {
              final isEnabled = snapshot.data ?? false;
              return Text(
                'Bluetooth Enable: $isEnabled',
                style: TextStyle(color: isEnabled ? VtbColors.vtbLightBlue : VtbColors.vtbRed),
              );
            },
          ),
      ],
    );
  }
}
