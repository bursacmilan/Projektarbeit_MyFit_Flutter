package ch.myfit.myfit_bmi

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "myfit_bmi/calculateBmi"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Warning: this method is invoked on the main thread.
                call, result ->
            if (call.method == "calculateBmi") {

                val param1: String? = call.argument("height")
                val param2: String? = call.argument("weight")

                val height = param1?.toDouble()
                val weight = param2?.toDouble()

                if (true) {
                    height?.let {
                        weight?.let {
                            result.success((height / (weight * weight)).toString())
                        }
                    }
                } else {
                    result.error("UNAVAILABLE", "server not available", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
