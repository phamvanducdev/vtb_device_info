package com.ducpv.vtb_device_info

import android.app.Activity
import com.ducpv.vtb_device_info.event_handlers.BluetoothEventHandler
import com.ducpv.vtb_device_info.event_handlers.InternetEventHandler
import com.ducpv.vtb_device_info.event_handlers.LocationEventHandler
import com.ducpv.vtb_device_info.helpers.ConnectionHelper
import com.ducpv.vtb_device_info.helpers.DeviceInfoHelper
import com.ducpv.vtb_device_info.helpers.LocationHelper
import com.ducpv.vtb_device_info.helpers.PermissionHelper
import com.ducpv.vtb_device_info.method_handlers.MethodHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class VtbDeviceInfoPlugin : FlutterPlugin, ActivityAware {
    private lateinit var methodChannel: MethodChannel
    private lateinit var internetEventChannel: EventChannel
    private lateinit var bluetoothEventChannel: EventChannel
    private lateinit var locationEventChannel: EventChannel

    private lateinit var deviceInfoHelper: DeviceInfoHelper
    private lateinit var connectionHelper: ConnectionHelper
    private lateinit var permissionHelper: PermissionHelper
    private lateinit var locationHelper: LocationHelper

    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        deviceInfoHelper = DeviceInfoHelper(context = binding.applicationContext)
        connectionHelper = ConnectionHelper(context = binding.applicationContext)
        permissionHelper = PermissionHelper(context = binding.applicationContext)
        locationHelper = LocationHelper(context = binding.applicationContext)

        methodChannel = MethodChannel(binding.binaryMessenger, "vtb_device_info")
        methodChannel.setMethodCallHandler(
            MethodHandler(
                activity = activity,
                deviceInfoHelper = deviceInfoHelper,
                connectionHelper = connectionHelper,
                permissionHelper = permissionHelper,
                locationHelper = locationHelper,
            )
        )

        internetEventChannel = EventChannel(binding.binaryMessenger, "vtb_device_info/internet")
        internetEventChannel.setStreamHandler(
            InternetEventHandler(
                context = binding.applicationContext,
                connectionHelper = connectionHelper,
            )
        )

        bluetoothEventChannel = EventChannel(binding.binaryMessenger, "vtb_device_info/bluetooth")
        bluetoothEventChannel.setStreamHandler(
            BluetoothEventHandler(
                context = binding.applicationContext,
                connectionHelper = connectionHelper,
            )
        )

        locationEventChannel = EventChannel(binding.binaryMessenger, "vtb_device_info/location")
        locationEventChannel.setStreamHandler(LocationEventHandler(context = binding.applicationContext))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        internetEventChannel.setStreamHandler(null)
        bluetoothEventChannel.setStreamHandler(null)
        locationEventChannel.setStreamHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        methodChannel.setMethodCallHandler(
            MethodHandler(
                activity = activity,
                deviceInfoHelper = deviceInfoHelper,
                connectionHelper = connectionHelper,
                permissionHelper = permissionHelper,
                locationHelper = locationHelper,
            )
        )
        binding.addRequestPermissionsResultListener(permissionHelper)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        methodChannel.setMethodCallHandler(
            MethodHandler(
                activity = activity,
                deviceInfoHelper = deviceInfoHelper,
                connectionHelper = connectionHelper,
                permissionHelper = permissionHelper,
                locationHelper = locationHelper,
            )
        )
        binding.addRequestPermissionsResultListener(permissionHelper)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
