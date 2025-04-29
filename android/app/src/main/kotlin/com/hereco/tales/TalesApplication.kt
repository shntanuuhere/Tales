package com.hereco.tales

import androidx.multidex.MultiDexApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.FlutterEngineCache

class TalesApplication : MultiDexApplication() {
    companion object {
        private const val ENGINE_ID = "tales_engine"
    }

    override fun onCreate() {
        super.onCreate()

        // Pre-warm the Flutter engine
        val flutterEngine = getFlutterEngine()
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
    }

    private fun getFlutterEngine(): FlutterEngine {
        // Create and cache the Flutter engine
        val engine = FlutterEngine(this)
        engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        return engine
    }
}
