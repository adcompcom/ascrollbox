package com.ascrollbox.ascrollbox

import android.content.Intent
import android.os.Bundle
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        publishShareTargetShortcut()
    }

    // Publishes the dynamic shortcut that backs the <share-target> declared
    // in res/xml/shortcuts.xml, so Android's Direct Share ranking has a
    // concrete target to rank/pin in other apps' native share sheets.
    private fun publishShareTargetShortcut() {
        val shortcut = ShortcutInfoCompat.Builder(this, "share_target")
            .setShortLabel(getString(R.string.app_name))
            .setLongLabel("Guardar en Ascrollbox")
            .setIcon(IconCompat.createWithResource(this, R.mipmap.ic_launcher))
            .setCategories(setOf("com.ascrollbox.ascrollbox.category.SHARE_TARGET"))
            .setIntent(Intent(this, ShareActivity::class.java).setAction(Intent.ACTION_VIEW))
            .build()
        ShortcutManagerCompat.pushDynamicShortcut(this, shortcut)
    }
}
