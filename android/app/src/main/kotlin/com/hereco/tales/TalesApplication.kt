package com.hereco.tales

import androidx.multidex.MultiDexApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.view.FlutterMain

class TalesApplication : MultiDexApplication() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialize Flutter before creating the engine
        FlutterMain.startInitialization(this)
        FlutterMain.ensureInitializationComplete(this, null)
        
        // Pre-warm the Flutter engine
        getFlutterEngine()
    }
    
    private fun getFlutterEngine(): FlutterEngine {
        // Create and cache the Flutter engine
        val engine = FlutterEngine(this)
        engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        return engine
    }
}
