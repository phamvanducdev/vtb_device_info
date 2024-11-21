package com.example.vtb_device_info.helpers

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.PluginRegistry

class PermissionHelper(private val context: Context) :
    PluginRegistry.RequestPermissionsResultListener {

    companion object {
        const val LOCATION_PERMISSION_REQUEST_CODE = 1001

        interface PermissionResultCallback {
            fun onResult(granted: Boolean)
        }
    }

    private var resultCallback: PermissionResultCallback? = null

    fun isLocationPermissionGranted(): Boolean {
        return ContextCompat.checkSelfPermission(
            context, Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }

    fun requestLocationPermission(activity: Activity?, resultCallback: PermissionResultCallback?) {
        if (isLocationPermissionGranted()) {
            resultCallback?.onResult(true)
        } else {
            if (activity == null) {
                throw Exception("Activity is missing.")
            }
            this.resultCallback = resultCallback;
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                LOCATION_PERMISSION_REQUEST_CODE,
            )
        }
    }

    /// REQUEST PERMISSION RESULT
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ): Boolean {
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            val granted =
                grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            resultCallback?.onResult(granted)
            return true
        }
        return false
    }
}