package com.foxdrop.core_alerts

import android.app.Activity
import android.content.Context
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

// The channel `fox_drop/core_alerts` (lib/src/alerts.dart): the receiving
// service, the ring, the chime and the device check. While a ring plays the
// activity shows over the lock screen and turns the screen on (RA §4.4);
// once it stops, the lock screen hides the app again.
class CoreAlertsPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private val ringingChanged: () -> Unit = { showOverLock(Ringer.ringing) }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "fox_drop/core_alerts")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startReceiving" -> {
                ReceivingService.start(context)
                result.success(null)
            }
            "wake" -> {
                if (ReceivingService.enabled(context)) ReceivingService.start(context)
                result.success(null)
            }
            "stopReceiving" -> {
                Ringer.stop(context)
                ReceivingService.stop(context)
                result.success(null)
            }
            "ring" -> {
                Ringer.ring(
                    context,
                    call.argument<String>("sound") ?: "fd_new_order",
                    call.argument<String>("title") ?: "",
                    call.argument<String>("body") ?: "",
                )
                result.success(null)
            }
            "stopRing" -> {
                Ringer.stop(context)
                result.success(null)
            }
            "chime" -> {
                Ringer.chime(context)
                result.success(null)
            }
            "readings" -> result.success(DeviceCheck.readings(context))
            "openSettings" -> {
                DeviceCheck.open(activity ?: context, call.argument<String>("setting") ?: "")
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    // Only the engine shown in the activity follows the ring (a push's
    // background engine has none).
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        Ringer.onRingingChanged = ringingChanged
        showOverLock(Ringer.ringing)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activity = null
        if (Ringer.onRingingChanged === ringingChanged) Ringer.onRingingChanged = null
    }

    @Suppress("DEPRECATION")
    private fun showOverLock(on: Boolean) {
        val shown = activity ?: return
        shown.runOnUiThread {
            if (Build.VERSION.SDK_INT >= 27) {
                shown.setShowWhenLocked(on)
                shown.setTurnScreenOn(on)
            } else {
                val flags =
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                if (on) shown.window.addFlags(flags) else shown.window.clearFlags(flags)
            }
        }
    }
}
