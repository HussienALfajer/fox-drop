package com.foxdrop.customer

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createPushChannels()
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
