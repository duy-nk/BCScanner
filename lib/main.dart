import 'dart:ui';

import 'package:app/CameraBarCode.dart';
import 'package:app/CameraS.dart';
import 'package:app/CameraScreen.dart';
import 'package:app/CameraTextScreen.dart';
import 'package:app/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    camerass = await availableCameras();
    camerasss = await availableCameras();
    camerassss = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCard Scanner',
      theme: ThemeData(
          primaryColor: Color(0xFFFFBD73),
          scaffoldBackgroundColor: Color(0xFF181818),
          textTheme: TextTheme(
              display1: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.deepOrange),
              headline: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 16.0))),
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Expanded(
        flex: 3,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/card.png"), fit: BoxFit.cover))),
      ),
      Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: "BCARD SCANNER\n",
                      style: Theme.of(context).textTheme.display1),
                  TextSpan(
                      text: "Scan Your Cards",
                      style: Theme.of(context).textTheme.headline)
                ])),
            FittedBox(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen();
                    },
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 25),
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFFFBD73),
                  ),
                  child: Row(children: <Widget>[
                    Text("START",
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
            )
          ]))
    ]));
  }
}
