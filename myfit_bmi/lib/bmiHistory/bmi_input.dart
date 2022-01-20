import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myfit_bmi/model/bmi.dart';
import 'package:myfit_bmi/services/data_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BmiInputWidget extends StatefulWidget {
  const BmiInputWidget({Key? key}) : super(key: key);

  @override
  State<BmiInputWidget> createState() => _BmiInputWidgetState();
}

class _BmiInputWidgetState extends State<BmiInputWidget> {
  String bmi = '';

  final TextEditingController textEditingControllerSize =
      TextEditingController();

  final TextEditingController textEditingControllerWeight =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  validateText(String? value) {
    if (value == null || value == '') {
      return "Bitte grösse eingeben.";
    }

    var result = int.tryParse(value);
    if (result == null) {
      return "Das ist keine Zahl";
    }

    return null;
  }

  List<charts.Series<Bmi, String>> getChartData() {
    return [
      charts.Series<Bmi, String>(
        id: 'BMI Data',
        data: DataService.instance.bmiHistory,
        domainFn: (bmi, index) => bmi.size.toString(),
        measureFn: (bmi, index) => bmi.size,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: charts.BarChart(
                  getChartData()
              ),
              height: 200,
            ),
            TextFormField(
              controller: textEditingControllerSize,
              validator: (value) => validateText(value),
              autofocus: true,
              autovalidateMode: AutovalidateMode.always,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Grösse in CM',
                  label: Text('Grösse in CM')),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: textEditingControllerWeight,
              validator: (value) => validateText(value),
              autofocus: true,
              autovalidateMode: AutovalidateMode.always,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Gewicht in KG',
                  label: Text('Gewicht in KG')),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState!.validate() == false) {
                      return;
                    }

                    var size = double.parse(textEditingControllerSize.text) / 100;
                    var weight = double.parse(textEditingControllerWeight.text);
                    var bmi = Bmi(weight, size);

                    this.bmi = bmi.getBmi().toString();
                  });
                },
                child: Text("BMI Berechnen")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState!.validate() == false) {
                      return;
                    }

                    var size = double.parse(textEditingControllerSize.text) / 100;
                    var weight = double.parse(textEditingControllerWeight.text);
                    var bmi = Bmi(weight, size);

                    this.bmi = bmi.getBmi().toString();
                    DataService.instance.addBmi(bmi);
                  });
                },
                child: Text("BMI Speichern")),
            const SizedBox(
              height: 20,
            ),
            Text('Dein BMI: ' + this.bmi + DataService.instance.bmiHistory.length.toString())
          ],
        ),
      ),
    );
  }
}
