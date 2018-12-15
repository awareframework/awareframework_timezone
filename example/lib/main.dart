import 'package:flutter/material.dart';

import 'package:awareframework_timezone/awareframework_timezone.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TimezoneSensor sensor;
  TimezoneSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = TimezoneSensorConfig()
      ..debug = true;

    sensor = new TimezoneSensor.init(config);

    sensor.start();
  }

  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new TimezoneCard(sensor: sensor,)
      ),
    );
  }
}
