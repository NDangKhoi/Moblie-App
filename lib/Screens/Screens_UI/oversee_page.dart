import 'package:flutter/material.dart';
import 'package:flutter_application_2/Widget/sensorwidget.dart';

class OverSeePage extends StatefulWidget {
  const OverSeePage({super.key});

  @override
  State<OverSeePage> createState() => _OverSeePageState();
}

class _OverSeePageState extends State<OverSeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000026),
      body: Container(
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff8e2ddd), Color(0xff5452ed)])),
        child: ListView(
          children: const [
            Column(children: [SensorWidget()])
          ],
        ),
      ),
    );
  }
}
