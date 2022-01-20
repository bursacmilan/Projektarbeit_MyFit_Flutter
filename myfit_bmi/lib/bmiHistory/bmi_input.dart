import 'package:flutter/material.dart';

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
    if(value == null || value == '') {
      return "Bitte grösse eingeben.";
    }

    var result = int.tryParse(value);
    if(result == null) {
      return "Das ist keine Zahl";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          ElevatedButton(onPressed: () {
            setState(() {
              if(_formKey.currentState!.validate() == false) {
                return;
              }

              var size = double.parse(textEditingControllerSize.text) / 100;
              var weight = double.parse(textEditingControllerWeight.text);

              this.bmi = (weight / (size * size)).round().toString();
            });
          }, child: Text("BMI Berechnen")),
          const SizedBox(
            height: 20,
          ),
          Text('Dein BMI: ' + this.bmi)
        ],
      ),
    );
  }
}
