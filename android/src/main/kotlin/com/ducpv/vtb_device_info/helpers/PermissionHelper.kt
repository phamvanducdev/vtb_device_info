package com.ducpv.vtb_device_info.helpers

import android.Manifest
import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.PluginRegistry

class PermissionHelper(private val context: Context) :
    PluginRegistry.RequestPermissionsResultListener {

    companion object {
        const val PERMISSION_REQUEST_CODE = 1001

        interface PermissionResultCallback {
            fun onResult(granted: Boolean)
        }
    }

    private var resultCallback: PermissionResultCallback? = null
    private var activity: Activity? = null

    /// CHECK PERMISSION
    fun isPermissionGranted(permission: String): Boolean {
        return ContextCompat.checkSelfPermission(
            context, permission
        ) == PackageManager.PERMISSION_GRANTED
    }

    /// REQUEST PERMISSION
    fun requestPermission(
        permission: String,
        activity: Activity?,
        resultCallback: PermissionResultCallback?,
    ) {
        if (isPermissionGranted(permission = permission)) {
            resultCallback?.onResult(true)
        } else {
            if (activity == null) {
                throw Exception("Activity is missing.")
            }
            this.resultCallback = resultCallback
            this.activity = activity
            if (isShowPermissionRationale(activity)) {
                openAppSettings(activity)
                return
            }
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(permission),
                PERMISSION_REQUEST_CODE,
            )
        }
    }

    /// REQUEST PERMISSION RESULT
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ): Boolean {
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (permissions.isEmpty()) {
                resultCallback?.onResult(false)
                return true
            }
            val isGranted = grantResults[0] == PackageManager.PERMISSION_GRANTED
            resultCallback?.onResult(isGranted)

            /// CHECK PERMISSION DENIED TO OPEN SETTINGS
            if (!isGranted && this.activity != null) {
                if (isShowPermissionRationale(this.activity!!)) {
                    openAppSettings(this.activity!!)
                    this.activity = null
                    return true
                }
            }
            resultCallback = null
            return true
        }
        return false
    }

    /// CHECK IF SHOULD SHOW RATIONALE
    private fun isShowPermissionRationale(
        activity: Activity,
        permission: String = Manifest.permission.ACCESS_FINE_LOCATION,
    ): Boolean {
        return ActivityCompat.shouldShowRequestPermissionRationale(activity, permission)
    }

    /// OPEN APP SETTINGS WITH DIALOG /// TODO remove LOCATIONS
    private fun openAppSettings(activity: Activity?) {
        if (activity == null) {
            throw Exception("Activity is missing.")
        }
        val builder = AlertDialog.Builder(activity)
        builder.setTitle("Location Access Denied")
        builder.setMessage("This app requires access to your device's location. Please enable location access for this app in Settings.")
        builder.setPositiveButton("Open Settings") { dialog, _ ->
            dialog.dismiss()
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.fromParts("package", activity.packageName, null)
            }
            activity.startActivity(intent)
        }
        builder.setNegativeButton("Cancel") { dialog, _ ->
            dialog.dismiss()
        }
        builder.create().show()
    }
}
