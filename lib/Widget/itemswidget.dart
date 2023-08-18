import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Services/data_device.dart';

class ItemsWidget extends StatefulWidget {
  const ItemsWidget({super.key});

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

// ignore: must_be_immutable
class _ItemsWidgetState extends State<ItemsWidget> {
  final _dataRTDB = FirebaseDatabase.instance.ref();
  // ignore: unused_field
  late StreamSubscription _streamBuilder;
  bool isPump = false;
  bool isFan = false;
  bool isRoof = false;
  bool isLed = false;
  bool isMode = false;
  bool isReset = false;

  String pump = '';
  String fan = '';
  String roof = '';
  String led = '';
  late String mode = '0';
  late String reset = '0';
  @override
  void initState() {
    super.initState();
    _dataDevice();
    _modeSystem();
    _resetSystem();
  }

  void _modeSystem() {
    _dataRTDB.child('Status/Mode').onValue.listen(
      (event) {
        setState(() {
          mode = event.snapshot.value.toString();
          if (mode == 'Auto') {
            isMode = true;
          } else if (mode == 'Manual') {
            isMode = false;
          }
        });
      },
    );
    _dataRTDB.child('System/Reset').onValue.listen(
      (event) {
        setState(() {
          reset = event.snapshot.value.toString();
        });
      },
    );
  }

  void _resetSystem() {}

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _dataDevice() {
    _streamBuilder = _dataRTDB.child('Status/Device').onValue.listen((event) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      final dataDevice = DataDevice.formRTDB(data);
      setState(() {
        pump = dataDevice.pumpData;
        if (pump == 'ON') {
          isPump = true;
        } else if (pump == 'OFF') {
          isPump = false;
        }
        led = dataDevice.lampData;
        if (led == 'ON') {
          isLed = true;
        } else if (led == 'OFF') {
          isLed = false;
        }
        fan = dataDevice.fanData;
        if (fan == 'ON') {
          isFan = true;
        } else if (fan == 'OFF') {
          isFan = false;
        }
        roof = dataDevice.stepperData;
        if (roof == 'CLOSE') {
          isRoof = true;
        } else if (roof == 'OPEN') {
          isRoof = false;
        }
      });
    });
  }

  Widget modeSwitch() => Transform.scale(
        scale: 2.5,
        child: SizedBox(
          child: Switch.adaptive(
            activeThumbImage: const AssetImage('images/ICON/Tick-green.png'),
            inactiveThumbImage: const AssetImage('images/ICON/Tick-red.png'),
            activeColor: const Color(0xff68f1ad),
            activeTrackColor: const Color(0xff68f1ad),
            inactiveThumbColor: const Color(0xfff65451),
            inactiveTrackColor: const Color(0xfff65451),
            value: isMode,
            onChanged: (isMode) {
              if (mode != 'Customer') {
                if (isMode) {
                  _dataRTDB.child('System/Mode').set("Auto");
                } else {
                  _dataRTDB.child('System/Mode').set("Manual");
                }
              }
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          childAspectRatio: 1.1,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 5, top: 10),
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
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: AnimatedSwitcher(
                            duration: const Duration(seconds: 2),
                            child: mode == 'Manual'
                                ? Image.asset('images/ICON/Manual.png',
                                    scale: 8)
                                : mode == 'Customer'
                                    ? Image.asset('images/ICON/Customer.png',
                                        scale: 8)
                                    : Image.asset('images/ICON/Auto.png',
                                        scale: 8),
                          ),
                        ),
                        Text(
                          mode,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ]),
                  const SizedBox(
                    height: 15,
                  ),
                  modeSwitch()
                ],
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
                  InkWell(
                    onLongPress: () {
                      _dataRTDB.child('System/Reset').set("ON");
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              reset != 'OFF'
                                  ? 'images/ICON/Reset-ON.png'
                                  : 'images/ICON/Reset_OFF.png',
                              scale: 8,
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.5),
                    child: Text(
                      reset == 'OFF' ? 'Active' : 'Resetting...',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: !isPump
                  ? InkWell(
                      key: const ValueKey('Pump_OFF'),
                      onTap: () {
                        if (mode == 'Manual') {
                          _dataRTDB.child('System/Manual/Pump').set("ON");
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xff9848E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'images/ICON/Pump-OFF.png',
                                      scale: 8,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Pump',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      key: const ValueKey('Pump_ON'),
                      onTap: () {
                        if (mode == 'Manual') {
                          _dataRTDB.child('System/Manual/Pump').set("OFF");
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffc7e5ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'images/ICON/pump.png',
                                      scale: 8,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Pump',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: !isLed
                  ? InkWell(
                      key: const ValueKey('led_OFF'),
                      onTap: () {
                        if (mode == 'Manual') {
                          _dataRTDB.child('System/Manual/Lamp').set("ON");
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xff9848E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'images/ICON/Led-OFF.png',
                                      scale: 8,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Lamp',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      key: const ValueKey('led_ON'),
                      onTap: () {
                        if (mode == 'Manual') {
                          _dataRTDB.child('System/Manual/Lamp').set("OFF");
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffc7e5ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'images/ICON/lampOn.png',
                                      scale: 8,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Lamp',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
        GridView.count(
          childAspectRatio: 1.1,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: !isFan
                  ? InkWell(
                      key: const ValueKey('Fan_OFF'),
                      onTap: () {
                        if (mode == 'Manual') {
                          _dataRTDB.child('System/Manual/Fan').set("ON");
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xff9848E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'images/ICON/Fan-OFF.png',
                                      scale: 8,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Fan',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      key: const ValueKey('Fan_ON'),
                      onTap: () {
                        if (mode == 'Manual') {
                          _dataRTDB.child('System/Manual/Fan').set("OFF");
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffc7e5ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'images/ICON/Fan.png',
                                      scale: 8,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Fan',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: !isRoof
                  ? InkWell(
                      key: const ValueKey('Roof_OFF'),
                      onTap: () {
                        if (mode == 'Manual') {
                          _dataRTDB.child('System/Manual/Stepper').set("ON");
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xff9848E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'images/ICON/Roof-OFF.png',
                                      scale: 8,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Roof',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      key: const ValueKey('Roof_ON'),
                      onTap: () {
                        if (mode == 'Manual') {
                          _dataRTDB.child('System/Manual/Stepper').set("OFF");
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffc7e5ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'images/ICON/roof.png',
                                      scale: 8,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Roof',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void deactivate() {
    _dataDevice();
    super.deactivate();
  }
}
