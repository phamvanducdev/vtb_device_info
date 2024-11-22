# vtb_device_info

A Flutter plugin designed to retrieve device information, check and listen for changes in Internet & Bluetooth status, location updates.

## Features

- **DeviceInfo**: Fetch detailed information about the device.
- **Internet**: Check if the device is connected to the internet and listen for connectivity changes.
- **Bluetooth**: Check if Bluetooth is enabled and listen for changes in its status.
- **Location**: Retrieve the current device location and subscribe to real-time location updates.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  # vtb_device_info: ^1.0.0
  vtb_device_info:
    git:
      url: https://github.com/phamvanducdev/vtb_device_info.git
      ref: main # or specify a specific branch, tag, or commit

```

Then, run:

```bash
flutter pub get
```

## Usage

### Import the Plugin

```dart
import 'package:vtb_device_info/vtb_device_info.dart';
```

### Initialize the Plugin

Use the singleton instance for accessing all features:

```dart
final deviceInfo = VtbDeviceInfo.instance;
```

### Examples

#### Get Device Information

```dart
DeviceInfo? info = await deviceInfo.getDeviceInfo();
if (info != null) {
  print("Device ID: ${info.deviceId}");
  print("Device Name: ${info.deviceName}");
  print("Device Model: ${info.deviceModel}");
}
```

#### Check Internet Connectivity

```dart
bool isConnected = await deviceInfo.checkInternetConnected();
print("Internet Connected: $isConnected");
```

#### Listen to Internet Status Changes

```dart
deviceInfo.registerInternetStatusChange.listen((isConnected) {
  print("Internet Status Changed: $isConnected");
});
```

#### Check Bluetooth Status

```dart
bool isBluetoothEnabled = await deviceInfo.checkBluetoothEnabled();
print("Bluetooth Enabled: $isBluetoothEnabled");
```

#### Listen to Bluetooth Status Changes

```dart
deviceInfo.registerBluetoothStatusChange.listen((isEnabled) {
  print("Bluetooth Status Changed: $isEnabled");
});
```

#### Get Current Location

```dart
DeviceLocation? location = await deviceInfo.getCurrentLocation();
if (location != null) {
  print("Latitude: ${location.latitude}, Longitude: ${location.longitude}");
}
```

#### Listen to Location Updates

```dart
deviceInfo.registerDeviceLocationChange.listen((location) {
  if (location != null) {
    print("Location Updated: Latitude=${location.latitude}, Longitude=${location.longitude}");
  }
});
```

#### Check Location Permission

```dart
bool isGranted = await deviceInfo.checkLocationPermissionGranted();
print("Location Permission Granted: $isGranted");
```

#### Request Location Permission

```dart
bool isGranted = await deviceInfo.requestLocationPermission();
if (isGranted) {
  print("Permission Granted");
} else {
  print("Permission Denied");
}
```

## Platform Integration

### Android

Update your `AndroidManifest.xml` to include required permissions:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS

Add the following keys to your `Info.plist` for location and Bluetooth permissions:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app requires location access to function properly.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app requires location access to function properly.</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app requires Bluetooth access to function properly.</string>
```

## Contributions

Contributions are welcome! Please submit issues or pull requests for any bugs or features you'd like to add.