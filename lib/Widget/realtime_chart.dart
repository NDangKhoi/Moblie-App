import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Services/data_sensor.dart';
import '../Services/semichart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RealTimeChart extends StatefulWidget {
  const RealTimeChart({super.key});

  @override
  State<RealTimeChart> createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> {
  final _sensorDataRTDB = FirebaseDatabase.instance.ref();
  // ignore: unused_field
  late StreamSubscription _streamBuilde;
  num _humiData = 0;
  num _lightData = 0;
  num _soilData = 0;
  num _tempData = 0;

  List<SalesDetails> sales = [];
  Future<String> getJsonFromFirebase() async {
    String url =
        'https://vuonthongminh-328d9-default-rtdb.firebaseio.com/HistoryChart.json';
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  Future loadSalesData() async {
    final String jsonString = await getJsonFromFirebase();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse) {
      sales.add(SalesDetails.fromJson(i));
    }
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
        _soilData = sensorData.soilData;
        _tempData = sensorData.tempData;
      });
    });
  }

  @override
  void initState() {
    loadSalesData();
    Timer.periodic(const Duration(seconds: 5), updateDataSource);
    _dataSensor();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void updateDataSource(Timer timer) {
    var time = DateFormat('HH:mm:ss').format(DateTime.now());
    sales.add(SalesDetails(_humiData.toString(), _lightData.toString(),
        _soilData.toString(), _tempData.toString(), time.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Chart',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: kScaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: ListView(children: [
        Column(
          children: [
            SizedBox(
              height: 270,
              child: FutureBuilder(
                future: getJsonFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return (SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Humidity Sensor'),
                      backgroundColor: const Color.fromARGB(255, 187, 201, 171),
                      // plotAreaBorderColor: Color(0xffd0e0bd),
                      series: <ChartSeries>[
                        LineSeries<SalesDetails, String>(
                            dataSource: sales,
                            xValueMapper: (SalesDetails details, _) =>
                                details.time,
                            yValueMapper: (SalesDetails details, _) =>
                                num.parse(details.humidity)),
                      ],
                    ));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              height: 270,
              child: FutureBuilder(
                future: getJsonFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return (SfCartesianChart(
                      backgroundColor: const Color(0xffe7f5f7),
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Light Sensor'),
                      series: <ChartSeries>[
                        LineSeries<SalesDetails, String>(
                            dataSource: sales,
                            // markerSettings: const MarkerSettings(
                            //     borderWidth: 2,
                            //     isVisible: true,
                            //     color: Colors.red),
                            xValueMapper: (SalesDetails details, _) =>
                                details.time,
                            yValueMapper: (SalesDetails details, _) =>
                                num.parse(details.light)),
                      ],
                    ));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              height: 270,
              child: FutureBuilder(
                future: getJsonFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return (SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Soil Sensor'),
                      series: <ChartSeries>[
                        LineSeries<SalesDetails, String>(
                            dataSource: sales,
                            xValueMapper: (SalesDetails details, _) =>
                                details.time,
                            yValueMapper: (SalesDetails details, _) =>
                                num.parse(details.soil)),
                      ],
                    ));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              height: 270,
              child: FutureBuilder(
                future: getJsonFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return (SfCartesianChart(
                      backgroundColor: const Color(0xfff0eef0),
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Temperature Sensor'),
                      series: <ChartSeries>[
                        LineSeries<SalesDetails, String>(
                            dataSource: sales,
                            xValueMapper: (SalesDetails details, _) =>
                                details.time,
                            yValueMapper: (SalesDetails details, _) =>
                                num.parse(details.temperature)),
                      ],
                    ));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ]),
    );
  }

  @override
  void deactivate() {
    _dataSensor();
    super.deactivate();
  }
}

class SalesDetails {
  SalesDetails(
      this.humidity, this.light, this.soil, this.temperature, this.time);
  final String humidity;
  final String light;
  final String soil;
  final String temperature;
  final String time;
  factory SalesDetails.fromJson(Map<String, dynamic> parsedJson) {
    return SalesDetails(
      parsedJson['Humidity'].toString(),
      parsedJson['Light'].toString(),
      parsedJson['Soil'].toString(),
      parsedJson['Temperature'].toString(),
      parsedJson['Time'].toString(),
    );
  }
}
