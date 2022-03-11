import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class BmiHistory extends StatefulWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  State<BmiHistory> createState() => _BmiHistoryState();
}

class _BmiHistoryState extends State<BmiHistory> {
  static const platformChannel = MethodChannel('myfit_bmi/server_connection');

  late Future<List<charts.Series<ChartBmi, int>>> data;

  Future<List<charts.Series<ChartBmi, int>>> loadData() async {
    try {
      List<Object?> remoteData = await platformChannel.invokeMethod('getAllData');
      List<ChartBmi> chartData = [];

      var index = 0;
      for (var single in remoteData) {
        single as double;
        chartData.add(ChartBmi(index, single.toInt()));
        index++;
      }

      return [
        charts.Series<ChartBmi, int>(
            id: 'bmi',
            domainFn: (bmi, index) => bmi.pos,
            measureFn: (bmi, index) => bmi.bmi,
            data: chartData)
      ];
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("PlatformException, look at the logs"),
      ));
      Logger().d(e.stacktrace);
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
    data = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<charts.Series<ChartBmi, int>>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.requireData.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: charts.LineChart(snapshot.requireData),
                ),
              ],
            );
          }
          return const Text('Loading ...');
        },
      ),
    );
  }
}

class ChartBmi {
  final int pos;
  final int bmi;

  ChartBmi(this.pos, this.bmi);
}
