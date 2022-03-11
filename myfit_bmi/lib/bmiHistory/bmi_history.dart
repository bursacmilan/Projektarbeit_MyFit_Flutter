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
  static const platform_channel = MethodChannel('myfit_bmi/server_connection');

  List<double> bmi = [];

  Future<int> _getItemCount() async {
    try {
      bmi = await platform_channel.invokeMethod('getAllData');
    } on PlatformException catch (e) {
      Logger().d(e.stacktrace);
    }

    setState(() {
      bmi = bmi;
    });

    return bmi.length;
  }



  List<charts.Series<ChartBmi, int>> _getData() {
    List<ChartBmi> data = [];

    var index = 0;
    for (var single in bmi) {
      data.add(ChartBmi(index, single.toInt()));
      index++;
    }

    return [
      charts.Series<ChartBmi, int>(
          id: 'bmi',
          domainFn: (bmi, index) => bmi.pos,
          measureFn: (bmi, index) => bmi.bmi,
          data: data)
    ];
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<int>(
        initialData: 0,
        future: _getItemCount(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: charts.LineChart(_getData()),
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
