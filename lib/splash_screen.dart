import 'dart:async';

import 'package:flutter/material.dart';
import 'package:importmanagementsystemonline/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  int _countdown = 2;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        _timer!.cancel();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        setState(() {
          _countdown = _countdown - 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                  ),
                ),
                SizedBox(
                  height: 170,
                ),
                Text(
                  'developed by',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/company.png',
                        fit: BoxFit.fitHeight,
                        width: MediaQuery.of(context).size.width / 7,
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      Text(
                        'MEET TECH LAB',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Contact :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          Text(
                            'meettechlab@gmail.com | ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purpleAccent),
                          ),
                          Text(
                            '+8801755460159',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
