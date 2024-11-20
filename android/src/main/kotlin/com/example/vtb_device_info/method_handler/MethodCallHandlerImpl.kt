package com.example.vtb_device_info.method_handler

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.provider.Settings.Secure.ANDROID_ID
import android.provider.Settings.Secure.getString
import com.example.vtb_device_info.helper.ConnectionHelper
import com.example.vtb_device_info.helper.DeviceInfoHelper
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
