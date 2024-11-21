import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtb_device_info/models/device_location.dart';
import 'package:vtb_device_info/vtb_device_info.dart';
import 'package:vtb_device_info_example/colors.dart';

class GetCurrentLocationWidget extends StatefulWidget {
  const GetCurrentLocationWidget({super.key});

  @override
  State<GetCurrentLocationWidget> createState() => _GetCurrentLocationWidgetState();
}

class _GetCurrentLocationWidgetState extends State<GetCurrentLocationWidget> {
  bool _permissionGranted = false;
  DeviceLocation? _currentLocation;
  String? _statusMessage;

  Future<void> checkPermissionGranted() async {
    _permissionGranted = await VtbDeviceInfo.instance.checkLocationPermissionGranted();
    setState(() {});
  }

  Future<void> requestPermission() async {
    _permissionGranted = await VtbDeviceInfo.instance.requestLocationPermission();
    setState(() {});
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      _currentLocation = null;
      _statusMessage = 'Loading...';
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _currentLocation = await VtbDeviceInfo.instance.getCurrentLocation();
      _statusMessage = null;
    } on PlatformException {
      _statusMessage = 'Failed to get current location.';
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkPermissionGranted();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_permissionGranted)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Location permission',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: VtbColors.vtbDartBlue),
              ),
              ElevatedButton(
                onPressed: requestPermission,
                child: const Text('Request Permission'),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Get Current Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: VtbColors.vtbDartBlue),
            ),
            ElevatedButton(
              onPressed: _permissionGranted ? getCurrentLocation : null,
              child: const Text('Get'),
            ),
          ],
        ),
        if (_statusMessage != null) Text(_statusMessage.toString()),
        if (_currentLocation != null)
          Text(
            _currentLocation.toString(),
            style: const TextStyle(color: VtbColors.vtbDartBlue),
          ),
      ],
    );
  }
}
