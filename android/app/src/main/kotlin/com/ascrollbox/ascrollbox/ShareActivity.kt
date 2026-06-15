package com.ascrollbox.ascrollbox

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class ShareActivity : FlutterActivity() {

    private var sharedText: String? = null

    // TextureView allows Flutter to render with transparency
    override fun getRenderMode(): RenderMode = RenderMode.texture

    // Send Flutter to the share route instead of the normal app
    override fun getInitialRoute(): String = "/share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        if (intent?.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ascrollbox/share")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getSharedText" -> result.success(sharedText)
                    "close"        -> { finish(); result.success(null) }
                    else           -> result.notImplemented()
                }
            }
    }
}
