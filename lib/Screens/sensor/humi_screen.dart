import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Semi/humi_semichart.dart';

import '../../Services/Limit/humi.dart';
import '../../Services/semichart.dart';

class HumiScreen extends StatefulWidget {
  const HumiScreen({super.key});

  @override
  State<HumiScreen> createState() => _HumiScreenState();
}

class _HumiScreenState extends State<HumiScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _sensorDataRTDB = FirebaseDatabase.instance.ref('System');
  TextEditingController low = TextEditingController();

  // ignore: unused_field
  late StreamSubscription _streamBuilde;
  String _lower = '0';
  String _higher = '0';
  String setLow = '0';
  String setHigh = "0";
  @override
  void initState() {
    _dataSensor();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _dataSensor() {
    _streamBuilde =
        _sensorDataRTDB.child('SetValue/Humidity').onValue.listen((event) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      final limitData = HumiLimit.formRTDB(data);
      setState(() {
        _lower = limitData.lower;
        _higher = limitData.higher;
      });
    });
  }

  Future<void> showInformationDialogLow(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController textEditingController =
              TextEditingController();
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: textEditingController,
                        validator: (value) => (value!.isEmpty)
                            ? null
                            : value.contains(',')
                                ? 'Error'
                                : num.parse(value) >= num.parse(_higher)
                                    ? 'Invalid Value'
                                    : null,
                        onChanged: (value) => {setState(() => setLow = value)},
                        style: Theme.of(context).textTheme.bodyLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _sensorDataRTDB
                              .child('SetValue/Humidity/LOW')
                              .set(setLow);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            );
          }));
        });
  }

  Future<void> showInformationDialogHigh(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController textEditingController =
              TextEditingController();
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: textEditingController,
                        validator: (value) => (value!.isEmpty)
                            ? null
                            : value.contains(',')
                                ? 'Error'
                                : num.parse(value) <= num.parse(_lower)
                                    ? 'Invalid Value'
                                    : null,
                        onChanged: (value) => {setState(() => setHigh = value)},
                        style: Theme.of(context).textTheme.bodyLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _sensorDataRTDB
                              .child('SetValue/Humidity/HIGH')
                              .set(setHigh);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            );
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kScaffoldBackgroundColor,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.transparent,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Humidity',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: Colors.white),
                ),
                const Text(
                  'Smart Garden',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'images/ICON/humi.png',
                  scale: 5,
                ),
              ]),
              const Expanded(child: HumiSemiChart()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Lower Limit',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await showInformationDialogLow(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(0.5),
                          child: Text(
                            '$_lower%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Higher Limit',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await showInformationDialogHigh(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(0.5),
                          child: Text(
                            '$_higher%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ]),
      ),
    );
  }

  @override
  void deactivate() {
    _dataSensor();
    super.deactivate();
  }
}
