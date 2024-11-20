package com.example.vtb_device_info.method_handlers

import android.content.Context
import android.os.Build
import com.example.vtb_device_info.helpers.ConnectionHelper
import com.example.vtb_device_info.helpers.DeviceInfoHelper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

internal class MethodCallHandlerImpl(private val context: Context) : MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDeviceInfo" -> {
                result.success(DeviceInfoHelper.getDeviceInfo(context))
            }

            "isInternetConnected" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    result.success(ConnectionHelper.isInternetConnected(context))
                } else {
                    result.notImplemented()
                }
            }

            "isBluetoothEnabled" -> {
                result.success(ConnectionHelper.isBluetoothEnabled(context))
            }

            else -> result.notImplemented()
        }
    }


}
