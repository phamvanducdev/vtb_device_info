package com.ducpv.vtb_device_info.helpers

import android.Manifest
import android.content.Context
import android.location.LocationManager

class LocationHelper(private val context: Context) {
    fun getCurrentLocation(): Map<String, Double>? {
        if (!PermissionHelper(context).isPermissionGranted(permission = Manifest.permission.ACCESS_FINE_LOCATION)) {
            throw IllegalStateException("Permission is not granted.")
        }
        val mLocationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val mLocation =
            mLocationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER) ?: return null
        return mapOf(
            "latitude" to mLocation.latitude,
            "longitude" to mLocation.longitude,
        )
    }
}