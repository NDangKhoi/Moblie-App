// ignore_for_file: avoid_print

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Screens/Screens_UI/control_page.dart';
import 'package:flutter_application_2/Screens/Screens_UI/history_page.dart';
import 'package:flutter_application_2/Screens/Screens_UI/oversee_page.dart';
import 'package:flutter_application_2/Screens/Screens_UI/profile_page.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  stt.SpeechToText speech = stt.SpeechToText();
  final _dataRTDB = FirebaseDatabase.instance.ref();

  bool _isListening = false;
  String _textSpeech = '';
  int _bottomNavIndex = 0;
  String mode = '';
  // List of the page Pages
  List<Widget> pages = const [
    ControlPage(),
    OverSeePage(),
    HistoryPage(),
    ProfilePage()
  ];

  ///List of the pages icons
  List<IconData> iconList = [
    Icons.home,
    Icons.sensors,
    Icons.history,
    Icons.person,
  ];
  // List of the pages titles
  List<String> titleList = ['Devices', 'Sensors', 'History', 'Profile'];

  void onListen() async {
    if (!_isListening) {
      bool available = await speech.initialize(
        onStatus: (val) => print('OnStatus: $val'),
        onError: (val) => print('OnError: $val'),
        debugLogging: true,
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        speech.listen(
            onResult: (val) => setState(() {
                  _textSpeech = val.recognizedWords;
                }));
      }
    } else {
      setState(() {
        _isListening = false;
      });
      speech.stop();
      handleVoice();
    }
  }

  void _modeSystem() {
    _dataRTDB.child('Status/Mode').onValue.listen(
      (event) {
        setState(() {
          mode = event.snapshot.value.toString();
        });
      },
    );
  }

  void handleVoice() {
    if (mode == 'Manual') {
      if (_textSpeech.contains('Turn off lamp') ||
          _textSpeech.contains('Tắt Đèn') ||
          _textSpeech.contains('Tắt đèn')) {
        _dataRTDB.child('System/Manual/Lamp').set("OFF");
      } else if (_textSpeech.contains('Turn on lamp') ||
          _textSpeech.contains('bật đèn') ||
          _textSpeech.contains('Mở đèn')) {
        _dataRTDB.child('System/Manual/Lamp').set("ON");
      } else if (_textSpeech.contains('Turn off Pump') ||
          _textSpeech.contains('tắt máy bơm') ||
          _textSpeech.contains('tex máy bơm') ||
          _textSpeech.contains('text mấy bơm') ||
          _textSpeech.contains('đóng máy bơm') ||
          _textSpeech.contains('tách máy bơm') ||
          _textSpeech.contains('tách me bơm') ||
          _textSpeech.contains('dừng máy bơm')) {
        _dataRTDB.child('System/Manual/Pump').set("OFF");
      } else if (_textSpeech.contains('Turn on Pump') ||
          _textSpeech.contains('bật máy bơm') ||
          _textSpeech.contains('mở máy bơm')) {
        _dataRTDB.child('System/Manual/Pump').set("ON");
      } else if (_textSpeech.contains('Turn off Roof') ||
          _textSpeech.contains('mở mái') ||
          _textSpeech.contains('Mở Mai Chi') ||
          _textSpeech.contains('mở máy Chi')) {
        _dataRTDB.child('System/Manual/Stepper').set("OFF");
      } else if (_textSpeech.contains('Turn on Roof') ||
          _textSpeech.contains('đóng máy Chi') ||
          _textSpeech.contains('đóng máy Chi') ||
          _textSpeech.contains('đóng Mai Chi') ||
          _textSpeech.contains('động mạch chi') ||
          _textSpeech.contains('đóng mái')) {
        _dataRTDB.child('System/Manual/Stepper').set("ON");
      } else if (_textSpeech.contains('Turn off Fan') ||
          _textSpeech.contains('tắt quạt')) {
        _dataRTDB.child('System/Manual/Fan').set("OFF");
      } else if (_textSpeech.contains('Turn on Fan') ||
          _textSpeech.contains('bật quạt') ||
          _textSpeech.contains('mở quạt')) {
        _dataRTDB.child('System/Manual/Fan').set("ON");
      } else if (_textSpeech.contains('auto mode') ||
          _textSpeech.contains('tự động')) {
        _dataRTDB.child('System/Mode').set("Auto");
      }
    } else if (_textSpeech.contains('manual mode') ||
        _textSpeech.contains('menu mode') ||
        _textSpeech.contains('bằng tay')) {
      _dataRTDB.child('System/Mode').set("Manual");
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    _modeSystem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleList[_bottomNavIndex],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xffa04df8),
        elevation: 0.0,
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: pages,
      ),
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 45.0,
        duration: const Duration(seconds: 2),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () => onListen(),
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Colors.blue,
        inactiveColor: Colors.white.withOpacity(0.9),
        icons: iconList,
        iconSize: 30,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: const Color(0xff1a52a3),
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
