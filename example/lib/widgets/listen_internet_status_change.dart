import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/vtb_device_info.dart';
import 'package:vtb_device_info_example/colors.dart';

class ListenInternetStatusChangeWidget extends StatefulWidget {
  const ListenInternetStatusChangeWidget({super.key});

  @override
  State<ListenInternetStatusChangeWidget> createState() => _ListenInternetStatusChangeWidgetState();
}

class _ListenInternetStatusChangeWidgetState extends State<ListenInternetStatusChangeWidget> {
  Stream<bool>? _statusStream;
  String? _statusMessage;

  Future<void> onRegister() async {
    setState(() {
      _statusStream = null;
      _statusMessage = 'Registering...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _statusStream = VtbDeviceInfo.instance.registerInternetStatusChange;
      _statusMessage = 'Listening...';
    } on PlatformException {
      _statusMessage = 'Failed to register internet status change.';
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
    _statusStream = null;
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
              'Listen Internet Status Change',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: VtbColors.vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: onRegister,
              child: const Text('Register'),
            ),
          ],
        ),
        if (_statusMessage != null) Text(_statusMessage.toString()),
        if (_statusStream != null)
          StreamBuilder<bool>(
            stream: _statusStream,
            builder: (context, snapshot) {
              final isConnected = snapshot.data ?? false;
              return Text(
                'Internet Connected: $isConnected',
                style: TextStyle(color: isConnected ? VtbColors.vtbLightBlue : VtbColors.vtbRed),
              );
            },
          ),
      ],
    );
  }
}
