// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime dateTime = DateTime(2023, 2, 1, 10, 20);
  int i = 0;
  get query => null;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoPageScaffold(
                  child: CupertinoButton(
                child: Text(i == 0
                    ? 'Select Date'
                    : dateTime.day < 10 && dateTime.month < 10
                        ? '0${dateTime.day}-0${dateTime.month}-${dateTime.year}'
                        : dateTime.day < 10 && dateTime.month >= 10
                            ? '0${dateTime.day}-${dateTime.month}-${dateTime.year}'
                            : dateTime.day >= 10 && dateTime.month < 10
                                ? '${dateTime.day}-0${dateTime.month}-${dateTime.year}'
                                : '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                onPressed: () {
                  i = 1;
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => SizedBox(
                            height: 250,
                            child: CupertinoDatePicker(
                              backgroundColor: Colors.white,
                              initialDateTime: dateTime,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() => dateTime = newTime);
                              },
                              use24hFormat: true,
                              mode: CupertinoDatePickerMode.date,
                            ),
                          ));
                },
              )),
            ],
          ),
          backgroundColor: const Color(0xffa04df8),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: FutureBuilder(
              future: getProducDataSource(
                  query: i == 0
                      ? null
                      : dateTime.day < 10 && dateTime.month < 10
                          ? '0${dateTime.day}-0${dateTime.month}-${dateTime.year}'
                          : dateTime.day < 10 && dateTime.month >= 10
                              ? '0${dateTime.day}-${dateTime.month}-${dateTime.year}'
                              : dateTime.day >= 10 && dateTime.month < 10
                                  ? '${dateTime.day}-0${dateTime.month}-${dateTime.year}'
                                  : '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? SfDataGrid(source: snapshot.data, columns: getColumns())
                    : const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      );
              }),
        ),
      ),
    );
  }

  Future<ProducDataGridSource> getProducDataSource({String? query}) async {
    var producList = await generateProducList();
    if (query != null) {
      producList = producList
          .where((element) =>
              element.Date.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return ProducDataGridSource(producList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'Date',
          width: 90,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Date',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
      GridColumn(
          columnName: 'Time',
          width: 80,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Time',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
      GridColumn(
          columnName: 'Mode',
          width: 80,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Mode',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
      GridColumn(
          columnName: 'Fan',
          width: 70,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Fan',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
      GridColumn(
          columnName: 'Lamp',
          width: 76,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Lamp',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
      GridColumn(
          columnName: 'Pump',
          width: 77,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Pump',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
      GridColumn(
          columnName: 'Stepper',
          width: 90,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Stepper',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
      GridColumn(
          columnName: 'Humidity',
          width: 80,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Column(
              children: [
                Text(
                  'Humi',
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
                Text(
                  '(%)',
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
              ],
            ),
          )),
      GridColumn(
          columnName: 'Light',
          width: 80,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Column(
              children: [
                Text(
                  'Light',
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
                Text(
                  '(Lux)',
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
              ],
            ),
          )),
      GridColumn(
          columnName: 'Weather',
          width: 95,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Weather',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
      GridColumn(
          columnName: 'Soil',
          width: 80,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Column(
              children: [
                Text(
                  'Soil',
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
                Text(
                  '(%)',
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
              ],
            ),
          )),
      GridColumn(
          columnName: 'Temperature',
          width: 80,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Column(
              children: [
                Text(
                  'Temp',
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
                Text(
                  '(°C)',
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
              ],
            ),
          )),
      GridColumn(
          columnName: 'Reset',
          width: 80,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Reset',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )),
    ];
  }

  Future refresh() async {
    setState(() {
      i = 0;
      generateProducList();
    });
  }

  Future<List<Product>> generateProducList() async {
    http.Response response = await http.get(Uri.parse(
        'https://vuonthongminh-328d9-default-rtdb.firebaseio.com/History.json'));

    var decodedProducts =
        json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product> producList = await decodedProducts
        .map<Product>((json) => Product.fromJson(json))
        .toList();

    return producList;
  }
}

class ProducDataGridSource extends DataGridSource {
  ProducDataGridSource(this.producList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<Product> producList;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      // Container(
      //   alignment: Alignment.centerLeft,
      //   padding: EdgeInsets.all(8.0),
      //   child: Text(
      //     DateFormat('dd-MM-yyyy').format(row.getCells()[0].value).toString(),
      //     overflow: TextOverflow.ellipsis,
      //   ),
      // ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[5].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[6].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[7].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[8].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[9].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[10].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[11].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          row.getCells()[12].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = producList.map<DataGridRow>((dataGridRows) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Date', value: dataGridRows.Date),
        DataGridCell<String>(columnName: 'Time', value: dataGridRows.Time),
        DataGridCell<String>(columnName: 'Mode', value: dataGridRows.Mode),
        DataGridCell<String>(columnName: 'Fan', value: dataGridRows.Fan),
        DataGridCell<String>(columnName: 'Lamp', value: dataGridRows.Lamp),
        DataGridCell<String>(columnName: 'Pump', value: dataGridRows.Pump),
        DataGridCell<String>(
            columnName: 'Stepper', value: dataGridRows.Stepper),
        DataGridCell<String>(
            columnName: 'Humidity', value: dataGridRows.Humidity),
        DataGridCell<String>(columnName: 'Light', value: dataGridRows.Light),
        DataGridCell<String>(columnName: 'Weather', value: dataGridRows.Rain),
        DataGridCell<String>(columnName: 'Soil', value: dataGridRows.Soil),
        DataGridCell<String>(
            columnName: 'Temperature', value: dataGridRows.Temperature),
        DataGridCell<bool>(columnName: 'Reset', value: dataGridRows.Reset)
      ]);
    }).toList(growable: false);
  }
}

class Product {
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        Date: json['Date'],
        Time: json['Time'],
        Mode: json['Mode'],
        Fan: json['Fan'],
        Lamp: json['Lamp'],
        Pump: json['Pump'],
        Stepper: json['Stepper'],
        Humidity: json['Humidity'],
        Light: json['Light'],
        Rain: json['Rain'],
        Soil: json['Soil'],
        Temperature: json['Temperature'],
        Reset: json['Reset']);
  }
  Product({
    required this.Date,
    required this.Time,
    required this.Mode,
    required this.Fan,
    required this.Lamp,
    required this.Pump,
    required this.Stepper,
    required this.Humidity,
    required this.Light,
    required this.Rain,
    required this.Soil,
    required this.Temperature,
    required this.Reset,
  });
  final String Date;
  final String Time;
  final String Mode;
  final String Fan;
  final String Lamp;
  final String Pump;
  final String Stepper;
  final String Humidity;
  final String Light;
  final String Rain;
  final String Soil;
  final String Temperature;
  final bool Reset;
}
