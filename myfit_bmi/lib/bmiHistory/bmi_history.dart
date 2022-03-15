import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:myfit_bmi/model/chart_value.dart';
import 'package:myfit_bmi/services/network_service.dart';

class BmiHistory extends StatefulWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  State<BmiHistory> createState() => _BmiHistoryState();
}

class _BmiHistoryState extends State<BmiHistory> {
  late Future<List<Series<ChartValue, int>>> data;

  @override
  void initState() {
    super.initState();
    data = NetworkService.instance.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Series<ChartValue, int>>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.requireData.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: LineChart(snapshot.requireData),
                ),
              ],
            );
          }
          return Container(
              width: double.infinity,
              height: 500,
              alignment: Alignment.center,
              child: const CircularProgressIndicator());
        },
      ),
    );
  }
}
