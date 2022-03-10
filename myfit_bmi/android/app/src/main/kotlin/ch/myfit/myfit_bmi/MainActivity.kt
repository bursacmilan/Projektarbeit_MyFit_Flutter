package ch.myfit.myfit_bmi

import androidx.annotation.NonNull
import ch.myfit.myfit_bmi.api_client.apis.BmiApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {

    private val CHANNEL = "myfit_bmi/calculateBmi"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "calculateBmi") {

                val param1: Double? = call.argument("height")
                val param2: Double? = call.argument("weight")

                val height = param1?.toFloat()
                val weight = param2?.toFloat()

                height?.let {
                    weight?.let {
                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                result.success(BmiApi().bmiCreatePost(weight, height, "deviceUuid"))
                            } catch (e: Exception) {
                                result.error(e.message, e.toString(), null)
                            }
                        }
                    }
                } ?: result.error("internal_error", "unexpected input", null);
            } else {
                result.notImplemented()
            }
        }
    }
}
