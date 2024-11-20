import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/models/device_info.dart';
import 'package:vtb_device_info/vtb_device_info.dart';

void main() {
  runApp(const VtbDeviceInfoApp());
}

const Color vtbRed = Color.fromRGBO(215, 18, 73, 1);
const Color vtbDartBlue = Color.fromRGBO(0, 89, 147, 1);
const Color vtbLightBlue = Color.fromRGBO(126, 211, 247, 1);

class VtbDeviceInfoApp extends StatefulWidget {
  const VtbDeviceInfoApp({super.key});

  @override
  State<VtbDeviceInfoApp> createState() => _VtbDeviceInfoAppState();
}

class _VtbDeviceInfoAppState extends State<VtbDeviceInfoApp> {
  final _vtbDeviceInfo = VtbDeviceInfo();

  @override
  void initState() {
    super.initState();
  }

  DeviceInfo? _deviceInfo;
  String? _deviceInfoMessage;

  Future<void> getDeviceInfo() async {
    setState(() {
      _deviceInfo = null;
      _deviceInfoMessage = 'Getting...';
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      _deviceInfo = await _vtbDeviceInfo.getDeviceInfo();
      _deviceInfoMessage = null;
    } on PlatformException {
      _deviceInfoMessage = 'Failed to get device info.';
    }

    if (!mounted) return;
    setState(() {});
  }

  bool? _isInternetConnected;
  String? _isInternetConnectedMessage;

  Future<void> onCheckInternetConnected() async {
    setState(() {
      _isInternetConnected = null;
      _isInternetConnectedMessage = 'Checking...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isInternetConnected = await _vtbDeviceInfo.isInternetConnected();
      _isInternetConnectedMessage = null;
    } on PlatformException {
      _isInternetConnectedMessage = 'Failed to check internet connected.';
    }

    if (!mounted) return;
    setState(() {});
  }

  Stream<bool>? _isInternetStatusStream;
  String? _isInternetStatusMessage;

  Future<void> onRegisterInternetChange() async {
    setState(() {
      _isInternetStatusStream = null;
      _isInternetStatusMessage = 'Registering...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isInternetStatusStream = _vtbDeviceInfo.registerInternetStatusChange;
      _isInternetStatusMessage = 'Listening...';
    } on PlatformException {
      _isInternetStatusMessage = 'Failed to register internet status change.';
    }

    if (!mounted) return;
    setState(() {});
  }

  bool? _isBluetoothEnabled;
  String? _isBluetoothEnabledMessage;

  Future<void> onCheckBluetoothEnabled() async {
    setState(() {
      _isBluetoothEnabled = null;
      _isBluetoothEnabledMessage = 'Checking...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isBluetoothEnabled = await _vtbDeviceInfo.isBluetoothEnabled();
      _isBluetoothEnabledMessage = null;
    } on PlatformException {
      _isBluetoothEnabledMessage = 'Failed to check bluetooth enabled.';
    }

    if (!mounted) return;
    setState(() {});
  }

  Stream<bool>? _isBluetoothStatusStream;
  String? _isBluetoothStatusMessage;

  Future<void> onRegisterBluetoothChange() async {
    setState(() {
      _isBluetoothStatusStream = null;
      _isBluetoothStatusMessage = 'Registering...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isBluetoothStatusStream = _vtbDeviceInfo.registerBluetoothStatusChange;
      _isBluetoothStatusMessage = 'Listening...';
    } on PlatformException {
      _isBluetoothStatusMessage = 'Failed to register bluetooth status change.';
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _isInternetStatusStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Vtb Device Info', style: TextStyle(color: vtbRed)),
          backgroundColor: vtbLightBlue,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGetDeviceInfoWidgets(context),
              const Divider(height: 32),
              _buildCheckInternetConnectedWidgets(context),
              const Divider(height: 32),
              _buildRegisterInternetChangeWidgets(context),
              const Divider(height: 32),
              _buildCheckBluetoothEnabledWidgets(context),
              const Divider(height: 32),
              _buildRegisterBluetoothChangeWidgets(context),
              const Divider(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  _buildGetDeviceInfoWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Get Device Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: vtbDartBlue),
            ),
            ElevatedButton(onPressed: getDeviceInfo, child: const Text('Get')),
          ],
        ),
        if (_deviceInfoMessage != null) Text(_deviceInfoMessage.toString()),
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
          )
      ],
    );
  }

  _buildCheckInternetConnectedWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Check Internet Connected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: onCheckInternetConnected,
              child: const Text('Check'),
            ),
          ],
        ),
        if (_isInternetConnectedMessage != null) Text(_isInternetConnectedMessage.toString()),
        if (_isInternetConnected != null) Text('Internet Connected: $_isInternetConnected'),
      ],
    );
  }

  _buildCheckBluetoothEnabledWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Check Bluetooth Enabled',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: onCheckBluetoothEnabled,
              child: const Text('Check'),
            ),
          ],
        ),
        if (_isBluetoothEnabledMessage != null) Text(_isBluetoothEnabledMessage.toString()),
        if (_isBluetoothEnabled != null) Text('Bluetooth Enabled: $_isBluetoothEnabled'),
      ],
    );
  }

  _buildRegisterInternetChangeWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Register Internet Change',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: onRegisterInternetChange,
              child: const Text('Register'),
            ),
          ],
        ),
        if (_isInternetStatusMessage != null) Text(_isInternetStatusMessage.toString()),
        if (_isInternetStatusStream != null)
          StreamBuilder<bool>(
            stream: _isInternetStatusStream,
            builder: (context, snapshot) {
              final isConnected = snapshot.data ?? false;
              return Text('Internet Connected: $isConnected');
            },
          ),
      ],
    );
  }

  _buildRegisterBluetoothChangeWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Register Bluetooth Change',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: onRegisterBluetoothChange,
              child: const Text('Register'),
            ),
          ],
        ),
        if (_isBluetoothStatusMessage != null) Text(_isBluetoothStatusMessage.toString()),
        if (_isBluetoothStatusStream != null)
          StreamBuilder<bool>(
            stream: _isBluetoothStatusStream,
            builder: (context, snapshot) {
              final isConnected = snapshot.data ?? false;
              return Text('Bluetooth Connected: $isConnected');
            },
          ),
      ],
    );
  }
}
