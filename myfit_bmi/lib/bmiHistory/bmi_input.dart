import 'package:flutter/material.dart';
import 'package:myfit_bmi/model/bmi.dart';
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
                onPressed: () {
                  if (_formKey.currentState!.validate() == false) {
                    return;
                  }

                  var size = double.parse(textEditingControllerSize.text) / 100;
                  var weight = double.parse(textEditingControllerWeight.text);
                  var bmi = Bmi(weight, size);

                  setState(() {
                    this.bmi = bmi.getBmi().toString();
                    currentBmi = bmi.getBmi();
                  });
                },
                child: Text("BMI Berechnen")),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
