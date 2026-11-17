package com.foxdrop.customer

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createPushChannels()
    }

    // The device block (docs/domain/08; slice 2.25d): the device id the
    // sign-in sends must survive a reinstall, so a blocked customer cannot
    // order again from the same phone with another number. Android ID stays
    // the same for this app's signing key until a factory reset; it is
    // turned into a name-based UUID (the server takes a UUID), never sent raw.
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.foxdrop.customer/device")
            .setMethodCallHandler { call, result ->
                if (call.method != "deviceId") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val androidId =
                    Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
                if (androidId.isNullOrBlank()) {
                    result.success(null)
                } else {
                    result.success(
                        UUID.nameUUIDFromBytes("fox-drop:$androidId".toByteArray()).toString(),
                    )
                }
            }
    }

    // The Android channels of the customer's pushes (CU §14, architecture
    // §8.2; packages/core_push/CLAUDE.md): the server names one per push, by
    // its level. They must exist before a push arrives while the app is
    // closed, so they are created natively at every start (creating an
    // existing channel changes nothing the customer set). Both are high
    // importance, so a push about the order shows on screen.
    private fun createPushChannels() {
        val manager = getSystemService(NotificationManager::class.java) ?: return
        manager.createNotificationChannel(
            NotificationChannel(
                "default",
                getString(R.string.push_channel_default),
                NotificationManager.IMPORTANCE_HIGH,
            ),
        )
        // The door ping (CU §14 row 5) rings with the phone's ringtone until
        // the app has its own sounds.
        manager.createNotificationChannel(
            NotificationChannel(
                "ring",
                getString(R.string.push_channel_ring),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                setSound(
                    RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE),
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
            },
        )
    }
}
