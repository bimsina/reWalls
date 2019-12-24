package com.bimsina.re_walls

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.IOException
import android.app.WallpaperManager
import android.graphics.BitmapFactory
import java.io.File
import android.os.Build
import android.annotation.TargetApi
import android.content.Context

private const val CHANNEL = "com.bimsina.re_walls/wallpaper"
private const val HOME = "setWallpaper"
private const val LOCK = "setLockWallpaper"

class MainActivity: FlutterActivity() {

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      print("call ${call.method}")
      if (call.method == HOME || call.method == LOCK) {
        val setWallpaper = setWallpaper(call.arguments as String, applicationContext)
        if (setWallpaper == 0) {
          result.success(setWallpaper)
        } else {
          result.error("UNAVAILABLE", "", null)
        }
      } else {
        result.notImplemented()
      }
    }
  }

  @TargetApi(Build.VERSION_CODES.ECLAIR)
  private fun setWallpaper(path: String, applicationContext: Context): Int {
    var setWallpaper = 1
    val bitmap = BitmapFactory.decodeFile(path)
    val wm: WallpaperManager? = WallpaperManager.getInstance(applicationContext)
    setWallpaper = try {
      wm?.setBitmap(bitmap)
      0
    } catch (e: IOException) {
      1
    }

    return setWallpaper
  }
}

