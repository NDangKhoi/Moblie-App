import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Screens/sensor/light_screen.dart';
import 'package:flutter_application_2/Screens/sensor/temp_screen.dart';
import 'package:flutter_application_2/Services/data_sensor.dart';
import 'package:flutter_application_2/Widget/realtime_chart.dart';
import 'package:page_transition/page_transition.dart';

import '../Screens/sensor/humi_screen.dart';
import '../Screens/sensor/soil_screen.dart';

class SensorWidget extends StatefulWidget {
  const SensorWidget({super.key});

  @override
  State<SensorWidget> createState() => _SensorWidgetState();
}

class _SensorWidgetState extends State<SensorWidget> {
  final _sensorDataRTDB = FirebaseDatabase.instance.ref();
  // ignore: unused_field
  late StreamSubscription _streamBuilde;
  num _humiData = 0;
  num _lightData = 0;
  String _rainData = '';
  num _soilData = 0;
  num _tempData = 0;

  @override
  void initState() {
    _dataSensor();
    super.initState();
  }

  void _dataSensor() {
    _streamBuilde =
        _sensorDataRTDB.child('Status/Sensor').onValue.listen((event) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      final sensorData = DataSensor.formRTDB(data);
      setState(() {
        _humiData = sensorData.humiData;
        _lightData = sensorData.lightData;
        _rainData = sensorData.rainData;
        _soilData = sensorData.soilData;
        _tempData = sensorData.tempData;
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GridView.count(
        childAspectRatio: 1.1,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xffc7e5ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const TempScreen(),
                        type: PageTransitionType.bottomToTop));
              },
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'images/ICON/temp.png',
                          scale: 8,
                        ),
                        const Text(
                          'Temperature',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        )
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.5),
                    child: Text(
                      '${_tempData.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xffc7e5ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        _rainData == 'Sunny'
                            ? 'images/ICON/Sunny.png'
                            : 'images/ICON/Rain.png',
                        scale: 8,
                      ),
                      const Text(
                        'Weather',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(0.5),
                  child: Text(
                    _rainData,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      GridView.count(
        childAspectRatio: 1.1,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xffc7e5ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const HumiScreen(),
                        type: PageTransitionType.bottomToTop));
              },
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'images/ICON/humi.png',
                          scale: 8,
                        ),
                        const Text(
                          'Humidity',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        )
                      ]),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.5),
                    child: Text(
                      '${_humiData.toStringAsFixed(1)} %',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xffc7e5ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const LightScreen(),
                        type: PageTransitionType.bottomToTop));
              },
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'images/ICON/lux.png',
                          scale: 8,
                        ),
                        const Text(
                          'Light',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ]),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.5),
                    child: Text(
                      '${_lightData.toStringAsFixed(1)} lux',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      GridView.count(
        childAspectRatio: 1.1,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xffc7e5ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const SoilScreen(),
                        type: PageTransitionType.bottomToTop));
              },
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'images/ICON/soil.png',
                          scale: 8,
                        ),
                        const Text(
                          'Soil moisture',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.5),
                    child: Text(
                      '${_soilData.toStringAsFixed(1)} %',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xffc7e5ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const RealTimeChart(),
                        type: PageTransitionType.bottomToTop));
              },
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'images/ICON/Chart.png',
                          scale: 8,
                        ),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Real Time Chart',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ]);
  }

  @override
  void deactivate() {
    _dataSensor();
    super.deactivate();
  }
}
