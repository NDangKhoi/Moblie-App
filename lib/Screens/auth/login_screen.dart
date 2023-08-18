// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../Services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                    gradients: [
                      [Colors.pink, const Color.fromARGB(255, 216, 108, 101)],
                      [Colors.pink, Colors.purple]
                    ],
                    durations: [
                      19440,
                      10800
                    ],
                    heightPercentages: [
                      0.20,
                      0.25
                    ],
                    blur: const MaskFilter.blur(BlurStyle.solid, 10),
                    gradientBegin: Alignment.bottomLeft,
                    gradientEnd: Alignment.topRight),
                waveAmplitude: 0,
                size: const Size(double.infinity, double.infinity),
              ),
            ),
          ),
          Column(children: [
            const SizedBox(height: 80),
            Image.asset('images/ICON/LOGO_UTH.png'),
          ]),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 80),
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: const ValueKey('email'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.pink),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: const UnderlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Email Address',
                          filled: true,
                          errorStyle: const TextStyle(
                              color: Colors.black, fontSize: 17),
                          prefixIcon: const Icon(Icons.email),
                          //labelText: 'Email Address',
                          fillColor: Theme.of(context).colorScheme.background),
                      validator: (val) => (val!.isEmpty)
                          ? 'Please enter a valid e-mail address.'
                          : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: const ValueKey('Password'),
                      validator: (val) => val!.length < 7
                          ? 'Enter a password 6+ chars long'
                          : null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.pink),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: const UnderlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Password',
                          filled: true,
                          errorStyle: const TextStyle(
                              color: Colors.black, fontSize: 17),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          //labelText: 'Password',
                          fillColor: Theme.of(context).colorScheme.background),
                      obscureText: _obscureText,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "forgotPassword");
                            },
                            child: const Text(
                              'Forgot Password?',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          )
                        ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 10),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(
                                          color: Colors.purple)))),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not sign in with those cedentials';
                                });
                              }
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              SizedBox(width: 7),
                              Icon(Icons.login),
                            ],
                          )),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    error,
                    style: (const TextStyle(color: Colors.red, fontSize: 14.0)),
                  )
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
