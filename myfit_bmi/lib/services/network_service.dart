import 'package:charts_flutter/flutter.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:myfit_bmi/model/chart_value.dart';

class NetworkService {
  static NetworkService instance = NetworkService();

  static const platformChannel = MethodChannel('myfit_bmi/server_connection');

  Future<List<Series<ChartValue, int>>> loadHistory() async {
    try {
      List<Object?> remoteData =
          await platformChannel.invokeMethod('getAllData');
      List<ChartValue> chartValues = [];

      var index = 0;
      for (var single in remoteData) {
        single as double;
        chartValues.add(ChartValue(index, single.toInt()));
        index++;
      }

      return [
        Series<ChartValue, int>(
            id: 'bmi',
            domainFn: (bmi, index) => bmi.x,
            measureFn: (bmi, index) => bmi.y,
            data: chartValues)
      ];
    } on Exception catch (e) {
      Logger().d(e);
      return Future.error(e);
    }
  }

  Future<double> calculateBmi(double height, double weight) async {
    try {
      return await platformChannel
          .invokeMethod('calculateBmi', {'height': height, 'weight': weight});
    } on PlatformException catch (e) {
      Logger().d(e.stacktrace);
      return 0;
    }
  }

  Future<void> deleteEntry(double timestamp) async {
    try {
      return await platformChannel
          .invokeMethod('deleteEntry', {'timestamp': timestamp});
    } on PlatformException catch (e) {
      Logger().d(e.stacktrace);
    }
  }
}
