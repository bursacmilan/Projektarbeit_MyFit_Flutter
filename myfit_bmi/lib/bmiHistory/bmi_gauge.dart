import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BmiGauge extends StatelessWidget {
  final int bmiValue;

  const BmiGauge({
    Key? key,
    required this.bmiValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 11.5,
          maximum: 40,
          showLabels: false,
          annotations: [
            GaugeAnnotation(
              widget: Center(
                child: Text(
                  bmiValue.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              angle: 90,
              positionFactor: 0.7,
            )
          ],
          pointers: [
            MarkerPointer(
              value: bmiValue.toDouble(),
              color: Colors.black,
              markerHeight: 20,
              markerWidth: 20,
            )
          ],
          ranges: [
            GaugeRange(
              startValue: 11.5,
              endValue: 17.5,
              color: Colors.red,
              startWidth: 50,
              endWidth: 50,
              label: '< 17.5',
            ),
            GaugeRange(
              startValue: 17.5,
              endValue: 24,
              color: Colors.green,
              startWidth: 50,
              endWidth: 50,
              label: '17.5 - 24',
            ),
            GaugeRange(
              startValue: 24,
              endValue: 29,
              color: Colors.yellow,
              startWidth: 50,
              endWidth: 50,
              label: '24 - 29',
            ),
            GaugeRange(
              startValue: 29,
              endValue: 34,
              color: Colors.orange,
              startWidth: 50,
              endWidth: 50,
              label: '29 - 34',
            ),
            GaugeRange(
              startValue: 34,
              endValue: 40,
              color: Colors.red,
              startWidth: 50,
              endWidth: 50,
              label: '> 34',
            )
          ],
        )
      ],
    );
  }
}
