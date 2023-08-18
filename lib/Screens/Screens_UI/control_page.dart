import 'package:flutter/material.dart';

import '../../Widget/itemswidget.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff8e2ddd), Color(0xff5452ed)])),
        child: ListView(
          children: const [
            Column(children: [ItemsWidget()])
          ],
        ),
      ),
    );
  }
}
