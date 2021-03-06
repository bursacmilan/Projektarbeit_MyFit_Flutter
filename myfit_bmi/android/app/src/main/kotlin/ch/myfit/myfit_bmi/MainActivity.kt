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

    private val CHANNEL = "myfit_bmi/server_connection"

    private var lastTimestamp = Double.MAX_VALUE

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "calculateBmi" -> {
                    val param1: Double? = call.argument("height")
                    val param2: Double? = call.argument("weight")

                    val height = param1?.toFloat()
                    val weight = param2?.toFloat()

                    height?.let {
                        weight?.let {
                            CoroutineScope(Dispatchers.IO).launch {
                                try {
                                    result.success(
                                        BmiApi().bmiCreatePost(
                                            weight,
                                            height,
                                            "deviceUuid"
                                        )
                                    )
                                } catch (e: Exception) {
                                    result.error(e.message, e.toString(), null)
                                }
                            }
                        }
                    } ?: result.error("internal_error", "unexpected input", null);
                }
                "getAllData" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val data = BmiApi().bmiAllDataGet("deviceUuid")
                            val list = mutableListOf<Double>()

                            for (element in data) {
                                val object123 = element as java.util.AbstractMap<*, *>
                                val weight = object123["weight"] as Double
                                val height = (object123["height"] as Double) / 100
                                list.add((weight / (height * height)))
                            }

                            val lastElement = data.last() as java.util.AbstractMap<*, *>
                            lastTimestamp = lastElement["timeStamp"] as Double

                            result.success(list)
                        } catch (e: Exception) {
                            result.error(e.message, e.toString(), null)
                        }
                    }
                }
                "deleteEntry" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            BmiApi().loginUser(lastTimestamp, "deviceUuid");
                            result.success(null);
                        } catch (e: Exception) {
                            result.error(e.message, e.toString(), null)
                        }
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
