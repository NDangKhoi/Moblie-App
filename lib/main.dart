// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Screens/auth/wrapper.dart';
import 'Screens/auth/forgotpassword_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => const Wrapper(),
      "forgotPassword": (context) => const ForgotPasswordPage(),
    },
  ));
}
