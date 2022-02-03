import 'package:flutter/material.dart';
import 'package:myfit_bmi/model/bmi.dart';
import 'package:myfit_bmi/services/persistence_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BmiHistory extends StatefulWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  State<BmiHistory> createState() => _BmiHistoryState();
}

class _BmiHistoryState extends State<BmiHistory> {
  List<Bmi> bmi = [];

  Future<int> _getItemCount() async {
    bmi = await PersistenceService.instance.loadAll();
    return bmi.length;
  }

  List<charts.Series<ChartBmi, int>> _getData() {
    List<ChartBmi> data = [];

    var index = 0;
    for (var single in bmi) {
      data.add(ChartBmi(index, single.getBmi()));
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
