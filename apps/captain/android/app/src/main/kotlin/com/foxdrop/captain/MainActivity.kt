package com.foxdrop.captain

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.Bundle
import com.foxdrop.core_alerts.ReceivingService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createPushChannels()
    }

    // CA §4.3–4.4 (slice 2.43, packages/core_alerts): one Flutter engine for
    // the app, kept when the activity is gone, so the work feed, the
    // location and the offer's ring go on while the background location's
    // foreground service keeps the process alive.
    override fun provideFlutterEngine(context: Context): FlutterEngine =
        ReceivingService.engine(context)

    override fun shouldDestroyEngineWithHost(): Boolean = false

    // CA §9.11 «طوارئ» (slice 2.13c): calls operations directly with the
    // call permission (CA §4.5 check 8), otherwise opens the dialer with the
    // number. Answers whether the call started directly.
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.foxdrop.captain/call")
            .setMethodCallHandler { call, result ->
                val phone = call.argument<String>("phone")
                if (call.method != "call" || phone == null) {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val direct = Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
                    checkSelfPermission(Manifest.permission.CALL_PHONE) ==
                    PackageManager.PERMISSION_GRANTED
                val action = if (direct) Intent.ACTION_CALL else Intent.ACTION_DIAL
                try {
                    startActivity(Intent(action, Uri.fromParts("tel", phone, null)))
                    result.success(direct)
                } catch (error: ActivityNotFoundException) {
                    result.error("no_dialer", error.message, null)
                }
            }
    }

    // The Android channels of the captain's pushes (CA §14, CA §4.4,
    // architecture §8.2; packages/core_push/CLAUDE.md): the server names one
    // per push, by its level. They must exist before a push arrives while
    // the app is closed, so they are created natively at every start
    // (creating an existing channel changes nothing the captain set).
    private fun createPushChannels() {
        val manager = getSystemService(NotificationManager::class.java) ?: return
        // A new offer rings with the bundled offer sound on the alarm stream
        // (slice 2.43); the push's background isolate also rings it, looping
        // over the lock screen (main.dart's ringOffer). A channel keeps its
        // first sound, so the bundled one has its own id (`ring_offer`, which
        // the server sends the offers to) and the earlier `offer` goes.
        manager.deleteNotificationChannel("offer")
        manager.createNotificationChannel(
            NotificationChannel(
                "ring_offer",
                getString(R.string.push_channel_offer),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                setSound(
                    Uri.parse("android.resource://$packageName/raw/fd_offer"),
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
            },
        )
        // A chime plays the notification sound once (CA §4.4).
        manager.createNotificationChannel(
            NotificationChannel(
                "chime",
                getString(R.string.push_channel_chime),
                NotificationManager.IMPORTANCE_HIGH,
            ),
        )
        // A withdrawal or cancellation (CA §14 rows 11-12) plays the phone's
        // notification sound until the bundled cancellation sound.
        manager.createNotificationChannel(
            NotificationChannel(
                "cancellation",
                getString(R.string.push_channel_cancellation),
                NotificationManager.IMPORTANCE_HIGH,
            ),
        )
        // A silent push only shows in the drawer.
        manager.createNotificationChannel(
            NotificationChannel(
                "silent",
                getString(R.string.push_channel_silent),
                NotificationManager.IMPORTANCE_LOW,
            ),
        )
    }
}
