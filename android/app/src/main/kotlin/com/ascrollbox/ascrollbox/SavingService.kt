package com.ascrollbox.ascrollbox

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

/**
 * Foreground service that performs the actual video save in a headless
 * FlutterEngine, independent of ShareActivity — so the save survives the
 * share sheet closing and the source app regaining focus. Shows the
 * SavingBubble notification for the duration of the work.
 */
class SavingService : Service() {

    private var engine: FlutterEngine? = null
    private var channel: MethodChannel? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val uid = intent?.getStringExtra(EXTRA_UID)
        val url = intent?.getStringExtra(EXTRA_URL)
        val tags = intent?.getStringArrayListExtra(EXTRA_TAGS) ?: arrayListOf()
        val isPrivate = intent?.getBooleanExtra(EXTRA_IS_PRIVATE, false) ?: false

        if (uid == null || url == null) {
            stopSelf(startId)
            return START_NOT_STICKY
        }

        val notification = SavingBubble.build(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                SavingBubble.NOTIFICATION_ID,
                notification,
                android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
            )
        } else {
            startForeground(SavingBubble.NOTIFICATION_ID, notification)
        }

        runHeadlessSave(uid, url, ArrayList(tags), isPrivate)
        return START_NOT_STICKY
    }

    private fun runHeadlessSave(
        uid: String,
        url: String,
        tags: ArrayList<String>,
        isPrivate: Boolean
    ) {
        val loader = FlutterInjector.instance().flutterLoader()
        if (!loader.initialized()) {
            loader.startInitialization(applicationContext)
        }
        loader.ensureInitializationComplete(applicationContext, null)

        // FlutterEngine's constructor already auto-registers plugins.
        val eng = FlutterEngine(this)
        engine = eng

        val ch = MethodChannel(eng.dartExecutor.binaryMessenger, "ascrollbox/bubble_save")
        channel = ch
        ch.setMethodCallHandler { call, result ->
            when (call.method) {
                "ready" -> {
                    ch.invokeMethod(
                        "save",
                        mapOf(
                            "uid" to uid,
                            "url" to url,
                            "tags" to tags,
                            "isPrivate" to isPrivate
                        )
                    )
                    result.success(null)
                }
                "done" -> {
                    result.success(null)
                    finishAndStop()
                }
                else -> result.notImplemented()
            }
        }

        // 3-arg form: the 2-arg constructor resolves the function only within
        // main.dart's library, but bubbleSaveMain lives in bubble_save.dart.
        val entrypoint = DartExecutor.DartEntrypoint(
            loader.findAppBundlePath(),
            "package:ascrollbox/bubble_save.dart",
            "bubbleSaveMain"
        )
        eng.dartExecutor.executeDartEntrypoint(entrypoint)
    }

    private fun finishAndStop() {
        SavingBubble.dismiss(this)
        engine?.destroy()
        engine = null
        @Suppress("DEPRECATION")
        stopForeground(true)
        stopSelf()
    }

    override fun onDestroy() {
        engine?.destroy()
        engine = null
        super.onDestroy()
    }

    companion object {
        const val EXTRA_UID = "uid"
        const val EXTRA_URL = "url"
        const val EXTRA_TAGS = "tags"
        const val EXTRA_IS_PRIVATE = "isPrivate"
    }
}
