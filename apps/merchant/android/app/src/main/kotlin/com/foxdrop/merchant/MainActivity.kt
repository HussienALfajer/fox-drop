package com.foxdrop.merchant

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.AudioAttributes
import android.net.Uri
import android.os.Bundle
import com.foxdrop.core_alerts.ReceivingService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createPushChannels()
    }

    // RA §4.3 (slice 2.42, packages/core_alerts): one Flutter engine for the
    // app, which the receiving service keeps running when the activity is
    // gone, so the board, its connection and its ring never depend on the
    // screen.
    override fun provideFlutterEngine(context: Context): FlutterEngine =
        ReceivingService.engine(context)

    override fun shouldDestroyEngineWithHost(): Boolean = false

    // The Android channels of the restaurant's pushes (RA §16, RA §4.4,
    // architecture §8.2; packages/core_push/CLAUDE.md): the server names one
    // per push, by its level. They must exist before a push arrives while
    // the app is closed, so they are created natively at every start
    // (creating an existing channel changes nothing the user set).
    private fun createPushChannels() {
        val manager = getSystemService(NotificationManager::class.java) ?: return
        // A new order, a pickup request or a cancellation rings with the
        // bundled new-order sound on the alarm stream (slice 2.42): the push
        // stands in while the app cannot ring itself (architecture §8.2). A
        // channel keeps its first sound, so the bundled one has its own id
        // (`ring_order`, which the server sends the restaurant's ring pushes
        // to) and the earlier `ring` channel goes.
        manager.deleteNotificationChannel("ring")
        manager.createNotificationChannel(
            NotificationChannel(
                "ring_order",
                getString(R.string.push_channel_ring),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                setSound(
                    Uri.parse("android.resource://$packageName/raw/fd_new_order"),
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
