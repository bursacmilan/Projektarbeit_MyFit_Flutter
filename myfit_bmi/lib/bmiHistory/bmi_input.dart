import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfit_bmi/services/network_service.dart';

import 'bmi_gauge.dart';

class BmiInputWidget extends StatefulWidget {
  const BmiInputWidget({Key? key}) : super(key: key);

  @override
  State<BmiInputWidget> createState() => _BmiInputWidgetState();
}

class _BmiInputWidgetState extends State<BmiInputWidget> {
  final TextEditingController textEditingControllerSize =
      TextEditingController();

  final TextEditingController textEditingControllerWeight =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  validateText(String? value, String error) {
    if (value == null || value == '') {
      return error;
    }

    var result = int.tryParse(value);
    if (result == null) {
      return "Das ist keine Zahl";
    }

    return null;
  }

  int calculatedBmi = 0;

  void calculateBmi(double height, double weight) async {
    NetworkService.instance.calculateBmi(height, weight).then((value) => {
          setState(() {
            calculatedBmi = value.toInt();
          })
        });
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
            SizedBox(
              child: BmiGauge(
                bmiValue: calculatedBmi,
              ),
              height: 200,
            ),
            TextFormField(
              controller: textEditingControllerSize,
              validator: (value) =>
                  validateText(value, "Bitte Grösse eingeben."),
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
              validator: (value) =>
                  validateText(value, "Bitte Gewicht eingeben."),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate() == false) {
                    return;
                  }
                  var height = double.parse(textEditingControllerSize.text);
                  var weight = double.parse(textEditingControllerWeight.text);
                  calculateBmi(height, weight);
                },
                child: const Text("Eintrag hinzufügen")),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
