package com.example.vtb_device_info.event_handler

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

internal class BluetoothEventCallHandlerImpl(private val context: Context) :
    EventChannel.StreamHandler {
    private var bluetoothReceiver: BroadcastReceiver? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        bluetoothReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == BluetoothAdapter.ACTION_STATE_CHANGED) {
                    val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, -1)
                    val isEnabled =
                        state == BluetoothAdapter.STATE_ON || state == BluetoothAdapter.STATE_TURNING_ON
                    sendEvent(isEnabled)
                }
            }
        }

        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(bluetoothReceiver, filter)
    }

    override fun onCancel(arguments: Any?) {
        if (bluetoothReceiver != null) {
            context.unregisterReceiver(bluetoothReceiver)
        }
        bluetoothReceiver = null
        eventSink = null
    }

    private fun sendEvent(isConnected: Boolean) {
        mainHandler.post {
            eventSink?.success(isConnected)
        }
    }
}