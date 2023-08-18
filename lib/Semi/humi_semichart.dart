import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../Services/semichart.dart';
import 'custom/customars.dart';

class HumiSemiChart extends StatefulWidget {
  const HumiSemiChart({super.key});

  @override
  State<HumiSemiChart> createState() => _HumiSemiChartState();
}

class _HumiSemiChartState extends State<HumiSemiChart> {
  final _dataRTDB = FirebaseDatabase.instance.ref();
  String humiData = "0";
  @override
  void initState() {
    super.initState();
    _tempdata();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _tempdata() {
    _dataRTDB.child('Status/Sensor/Humidity').onValue.listen(
      (event) {
        setState(() {
          humiData = event.snapshot.value.toString();
        });
      },
    );
  }

  double progessVal = 0.5;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                      startAngle: degToRad(0),
                      endAngle: degToRad(220),
                      colors: [Colors.blue, Colors.red.withAlpha(150)],
                      stops: [progessVal, progessVal],
                      transform: GradientRotation(degToRad(178)))
                  .createShader(rect);
            },
            child: const Center(
              child: CustomArc(),
            )),
        Center(
          child: Container(
            width: kDiameter - 30,
            height: kDiameter - 30,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 20,
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 30,
                      spreadRadius: 10,
                      color: Colors.pink
                          .withAlpha(normalize(progessVal, 100, 255).toInt()),
                      offset: const Offset(1, 3))
                ]),
            child: SleekCircularSlider(
              min: 0,
              max: 100,
              initialValue: double.parse(humiData),
              appearance: CircularSliderAppearance(
                  startAngle: 180,
                  angleRange: 180,
                  size: kDiameter - 30,
                  customWidths: CustomSliderWidths(
                      trackWidth: 10,
                      shadowWidth: 0,
                      progressBarWidth: 01,
                      handlerSize: 15),
                  customColors: CustomSliderColors(
                    hideShadow: true,
                    progressBarColor: Colors.transparent,
                    trackColor: Colors.transparent,
                    dotColor: Colors.red,
                  )),
              innerWidget: (soilData) {
                return Center(
                  child: Text(
                    '${soilData.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 50),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}