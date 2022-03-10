import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfit_bmi/model/bmi.dart';
import 'package:myfit_bmi/services/persistence_service.dart';
import 'bmi_gauge.dart';

class BmiInputWidget extends StatefulWidget {
  const BmiInputWidget({Key? key}) : super(key: key);

  @override
  State<BmiInputWidget> createState() => _BmiInputWidgetState();
}

class _BmiInputWidgetState extends State<BmiInputWidget> {
  String bmi = '';
  int currentBmi = 0;

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

  static const platform = MethodChannel('myfit_bmi/calculateBmi');

  String bmiResult = 'unknown bmi.';

  Future<void> calculateBmi(String weight, String height) async {
    String bmi;
    try {
      final String result = await platform.invokeMethod('calculateBmi', {'weight':weight, 'height':height});
      bmi = 'bmi is $result';
    } on PlatformException catch (e) {
      bmi = "failed to get bmi: '${e.message}'.";
    }

    setState(() {
      bmiResult = bmi;
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
                bmiValue: currentBmi,
              ),
              height: 200,
            ),
            TextFormField(
              controller: textEditingControllerSize,
              validator: (value) => validateText(value, "Bitte Grösse eingeben."),
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
              validator: (value) => validateText(value, "Bitte Gewicht eingeben."),
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

                  var size = double.parse(textEditingControllerSize.text) / 100;
                  var weight = double.parse(textEditingControllerWeight.text);
                  var bmi = Bmi(weight, size);

                  await PersistenceService.instance.saveNew(bmi);

                  setState(() {
                    this.bmi = bmi.getBmi().toString();
                    currentBmi = bmi.getBmi();
                  });
                },
                child: const Text("BMI Berechnen")),
            ElevatedButton(
                onPressed: () async {
                  calculateBmi("80", "180");
                },
                child: const Text("test plattform api")),

            Text(
              bmiResult,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 40)),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
