package com.ascrollbox.ascrollbox

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat

/**
 * Native Android Bubble shown while a shared video is being saved —
 * a floating icon (Messenger-style) instead of a blocking in-app overlay.
 */
object SavingBubble {
    // Renamed from "saving_bubble" — channel importance can't be changed
    // in code once a channel exists, only re-created under a new id.
    private const val CHANNEL_ID = "saving_bubble_v2"
    private const val SHORTCUT_ID = "saving_bubble_shortcut"
    const val NOTIFICATION_ID = 4201

    fun build(context: Context): Notification {
        ensureChannel(context)

        val icon = IconCompat.createWithResource(context, R.mipmap.ic_launcher)

        val person = Person.Builder()
            .setName(context.getString(R.string.app_name))
            .setIcon(icon)
            .setImportant(true)
            .build()

        val shortcut = ShortcutInfoCompat.Builder(context, SHORTCUT_ID)
            .setLongLived(true)
            .setShortLabel(context.getString(R.string.app_name))
            .setIcon(icon)
            .setPerson(person)
            .setCategories(setOf("com.ascrollbox.ascrollbox.category.SHARE_TARGET"))
            .setIntent(Intent(context, MainActivity::class.java).setAction(Intent.ACTION_VIEW))
            .build()
        ShortcutManagerCompat.pushDynamicShortcut(context, shortcut)

        val contentIntent = Intent(context, MainActivity::class.java)
            .setAction(Intent.ACTION_VIEW)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_DOCUMENT or Intent.FLAG_ACTIVITY_MULTIPLE_TASK)
        val contentPendingIntent = PendingIntent.getActivity(
            context, 0, contentIntent,
            PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val bubbleMetadata = NotificationCompat.BubbleMetadata.Builder(contentPendingIntent, icon)
            .setDesiredHeight(600)
            .setAutoExpandBubble(false)
            .build()

        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(context.getString(R.string.app_name))
            .setStyle(
                NotificationCompat.MessagingStyle(person)
                    .addMessage(
                        context.getString(R.string.saving_notification_text),
                        System.currentTimeMillis(),
                        person
                    )
            )
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setShortcutId(SHORTCUT_ID)
            .addPerson(person)
            .setBubbleMetadata(bubbleMetadata)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setSilent(true)
            .setAutoCancel(true)
            .build()
    }

    fun dismiss(context: Context) {
        NotificationManagerCompat.from(context).cancel(NOTIFICATION_ID)
    }

    private fun ensureChannel(context: Context) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.deleteNotificationChannel("saving_bubble") // old HIGH-importance channel
        if (nm.getNotificationChannel(CHANNEL_ID) != null) return

        val channel = NotificationChannel(
            CHANNEL_ID,
            context.getString(R.string.saving_channel_name),
            NotificationManager.IMPORTANCE_DEFAULT
        )
        channel.setSound(null, null)
        channel.enableVibration(false)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            channel.setAllowBubbles(true)
        }
        nm.createNotificationChannel(channel)
    }
}
