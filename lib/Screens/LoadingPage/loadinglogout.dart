import 'package:flutter/material.dart';
import 'package:flutter_application_2/Screens/auth/wrapper.dart';

class LoadingLogout extends StatefulWidget {
  const LoadingLogout({super.key});

  @override
  State<LoadingLogout> createState() => _LoadingLogoutState();
}

class _LoadingLogoutState extends State<LoadingLogout> {
  bool loading = true;
  void loadData() async {
    await Future.delayed(const Duration(milliseconds: 750), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Wrapper()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff8e2ddd), Color(0xff5452ed)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/ICON/iconAppbar.png',
              scale: 6,
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Color.fromARGB(255, 255, 179, 64),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
