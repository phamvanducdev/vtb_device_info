package com.ducpv.vtb_device_info.method_handlers

import android.app.Activity
import android.os.Build
import android.os.Handler
import android.os.Looper
import com.ducpv.vtb_device_info.helpers.ConnectionHelper
import com.ducpv.vtb_device_info.helpers.DeviceInfoHelper
import com.ducpv.vtb_device_info.helpers.LocationHelper
import com.ducpv.vtb_device_info.helpers.PermissionHelper
import com.ducpv.vtb_device_info.helpers.PermissionHelper.Companion.PermissionResultCallback
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

internal class MethodHandler(
    private val activity: Activity?,
    private val deviceInfoHelper: DeviceInfoHelper,
    private val connectionHelper: ConnectionHelper,
    private val permissionHelper: PermissionHelper,
    private val locationHelper: LocationHelper,
) : MethodCallHandler {
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDeviceInfo" -> onHandleGetDeviceInfo(result)
            "checkInternetConnected" -> onHandleCheckInternetConnected(result)
            "checkBluetoothEnabled" -> onHandleCheckBluetoothEnabled(result)
            "getCurrentLocation" -> onHandleGetCurrentLocation(result)
            "checkLocationPermissionGranted" -> onHandleCheckLocationPermissionGranted(result)
            "requestLocationPermission" -> onHandleRequestLocationPermission(result)
            else -> result.notImplemented()
        }
    }

    private fun onHandleGetDeviceInfo(result: MethodChannel.Result) {
        result.success(deviceInfoHelper.getDeviceInfo())
    }

    private fun onHandleCheckInternetConnected(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            result.success(connectionHelper.isInternetConnected())
        } else {
            result.notImplemented()
        }
    }

    private fun onHandleCheckBluetoothEnabled(result: MethodChannel.Result) {
        result.success(connectionHelper.isBluetoothEnabled())
    }

    private fun onHandleGetCurrentLocation(result: MethodChannel.Result) {
        result.success(locationHelper.getCurrentLocation())
    }

    private fun onHandleCheckLocationPermissionGranted(result: MethodChannel.Result) {
        result.success(permissionHelper.isLocationPermissionGranted())
    }

    private fun onHandleRequestLocationPermission(result: MethodChannel.Result) {
        permissionHelper.requestLocationPermission(
            activity = activity,
            resultCallback = object : PermissionResultCallback {
                override fun onResult(granted: Boolean) {
                    mainHandler.post { result.success(granted) }
                }
            },
        )
    }
}
