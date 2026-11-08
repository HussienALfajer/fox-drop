package com.foxdrop.merchant

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

    // The Android channels of the restaurant's pushes (RA §16, RA §4.4,
    // architecture §8.2; packages/core_push/CLAUDE.md): the server names one
    // per push, by its level. They must exist before a push arrives while
    // the app is closed, so they are created natively at every start
    // (creating an existing channel changes nothing the user set).
    private fun createPushChannels() {
        val manager = getSystemService(NotificationManager::class.java) ?: return
        // A new order or a pickup request rings with the phone's alarm sound
        // on the alarm stream, as the app's own ring does, until the bundled
        // sounds.
        manager.createNotificationChannel(
            NotificationChannel(
                "ring",
                getString(R.string.push_channel_ring),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                setSound(
                    RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM),
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
            },
        )
        // A chime plays the notification sound once (RA §4.4).
        manager.createNotificationChannel(
            NotificationChannel(
                "chime",
                getString(R.string.push_channel_chime),
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
