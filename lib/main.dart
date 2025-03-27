import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

void main() {
  runApp(const CompassApp());
}

class CompassApp extends StatefulWidget {
  const CompassApp({super.key});

  @override
  State<CompassApp> createState() => _CompassAppState();
}

class _CompassAppState extends State<CompassApp> {
  double? heading;
  String directionText = "Güneşi Güneşe Getirin";
  String appBarTitle = "Güneşi Güneşe Getirin";

  @override
  void initState() {
    super.initState();

    FlutterCompass.events?.listen((event) {
      setState(() {
        heading = event.heading;
      });
    });

    accelerometerEventStream().listen((event) {
      if (heading != null) {
        if (heading! >= 170 && heading! <= 190) {
          directionText = "Güney";
          appBarTitle = "Compass APP";
        } else {
          appBarTitle = "Güneşi Güneşe Getirin";
          if (event.x > 3) {
            directionText = "Sola Çeviriniz";
          }
          if (event.x < -3) {
            directionText = "Sağa Çeviriniz";
          }
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Container(
              height: 40,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: Colors.blue.shade50,
              ),
              child: Center(
                child: Text(
                  appBarTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/sun.png', height: 100, width: 100),
              Stack(
                alignment: Alignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.modulate),
                    child: Image.asset(
                      'assets/images/frame.png',
                      width: 350,
                      height: 350,
                    ),
                  ),
                  Transform.rotate(
                    angle: ((heading ?? 0) * (math.pi / 180) * -1),
                    child: Image.asset(
                      'assets/images/compass.png',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                directionText,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: directionText == "Güney" ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blue.shade50,
      ),
    );
  }
}