package com.ducpv.vtb_device_info.event_handlers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.Network
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.annotation.RequiresApi
import com.ducpv.vtb_device_info.helpers.ConnectionHelper
import io.flutter.plugin.common.EventChannel

internal class InternetEventHandler(
    private val context: Context?,
    private val connectionHelper: ConnectionHelper,
) : EventChannel.StreamHandler {
    private var networkCallback: ConnectivityManager.NetworkCallback? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var receiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            networkCallback = object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    sendEvent(true)
                }

                override fun onLost(network: Network) {
                    sendEvent(false)
                }
            }
            val connectivityManager =
                context?.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            connectivityManager.registerDefaultNetworkCallback(networkCallback!!)
        } else {
            receiver = object : BroadcastReceiver() {
                @RequiresApi(Build.VERSION_CODES.M)
                override fun onReceive(context: Context, intent: Intent) {
                    sendEvent(connectionHelper.isInternetConnected())
                }
            }
            val intentFilter = IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION)
            context?.registerReceiver(receiver, intentFilter)
        }

    }

    override fun onCancel(arguments: Any?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            if (networkCallback != null) {
                val connectivityManager =
                    context?.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                connectivityManager.unregisterNetworkCallback(networkCallback!!)
            }
        } else {
            if (receiver != null) {
                context?.unregisterReceiver(receiver)
            }
        }
        eventSink = null
    }

    private fun sendEvent(isConnected: Boolean) {
        mainHandler.post {
            eventSink?.success(isConnected)
        }
    }

}
