import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../LoadingPage/loadinglogout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff8e2ddd), Color(0xff5452ed)])),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 64,
                ),
                Text(
                  'Signed in as: ${user!.email}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const Icon(
                  Icons.logout,
                  color: Colors.black,
                  size: 64,
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoadingLogout()),
                          (Route<dynamic> route) => false);
                    },
                    child: const Text(
                      'Log out',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
