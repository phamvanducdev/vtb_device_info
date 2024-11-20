package com.example.vtb_device_info

import com.example.vtb_device_info.event_handler.BluetoothEventCallHandlerImpl
import com.example.vtb_device_info.event_handler.InternetEventCallHandlerImpl
import com.example.vtb_device_info.method_handler.MethodCallHandlerImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class VtbDeviceInfoPlugin : FlutterPlugin {
    private lateinit var methodChannel: MethodChannel
    private lateinit var internetEventChannel: EventChannel
    private lateinit var bluetoothEventChannel: EventChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "vtb_device_info")
        methodChannel.setMethodCallHandler(MethodCallHandlerImpl(binding.applicationContext))

        internetEventChannel =
            EventChannel(binding.binaryMessenger, "vtb_device_info/internet_status")
        internetEventChannel.setStreamHandler(InternetEventCallHandlerImpl(binding.applicationContext))

        bluetoothEventChannel =
            EventChannel(binding.binaryMessenger, "vtb_device_info/bluetooth_status")
        bluetoothEventChannel.setStreamHandler(BluetoothEventCallHandlerImpl(binding.applicationContext))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        internetEventChannel.setStreamHandler(null)
        bluetoothEventChannel.setStreamHandler(null)
    }
}
