import 'package:flutter/material.dart';
import 'package:vtb_device_info_example/colors.dart';
import 'package:vtb_device_info_example/widgets/get_current_bluetooth_status.dart';
import 'package:vtb_device_info_example/widgets/get_current_location.dart';
import 'package:vtb_device_info_example/widgets/get_current_internet_status.dart';
import 'package:vtb_device_info_example/widgets/get_device_info.dart';
import 'package:vtb_device_info_example/widgets/listen_bluetooth_status_change.dart';
import 'package:vtb_device_info_example/widgets/listen_current_location_change.dart';
import 'package:vtb_device_info_example/widgets/listen_internet_status_change.dart';

void main() {
  runApp(const VtbDeviceInfoApp());
}

class VtbDeviceInfoApp extends StatefulWidget {
  const VtbDeviceInfoApp({super.key});

  @override
  State<VtbDeviceInfoApp> createState() => _VtbDeviceInfoAppState();
}

class _VtbDeviceInfoAppState extends State<VtbDeviceInfoApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Vtb Device Info', style: TextStyle(color: VtbColors.vtbRed)),
          backgroundColor: VtbColors.vtbLightBlue,
        ),
        body: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetDeviceInfoWidget(),
              Divider(height: 32),
              GetCurrentInternetStatusWidget(),
              Divider(height: 32),
              ListenInternetStatusChangeWidget(),
              Divider(height: 32),
              GetCurrentBluetoothStatusWidget(),
              Divider(height: 32),
              ListenBluetoothStatusChangeWidget(),
              Divider(height: 32),
              GetCurrentLocationWidget(),
              Divider(height: 32),
              ListentCurrentLocationChangeWidget(),
              Divider(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
