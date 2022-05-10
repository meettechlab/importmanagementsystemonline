import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsystemonline/screens/archive.dart';
import 'package:importmanagementsystemonline/screens/dashboard.dart';
import 'package:importmanagementsystemonline/screens/login_screen.dart';
import 'package:importmanagementsystemonline/splash_screen.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCBOHqptuFvei3ZBDUc-Y0S5Gg3Z0tJhnA",
        authDomain: "import-management-system.firebaseapp.com",
        projectId: "import-management-system",
        storageBucket: "import-management-system.appspot.com",
        messagingSenderId: "1019762685191",
        appId: "1:1019762685191:web:81516a45c3bc836abf01a2",
        measurementId: "G-8W3VQRM53H"
    ),
  );
  runApp(const MyApp());

}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
