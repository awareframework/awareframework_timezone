import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';


/// The Timezone measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = TimezoneSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  TimezoneSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = TimezoneSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<TimezoneData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onTimezoneChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = TimezoneCard(sensor: sensor);
/// ```
class TimezoneSensor extends AwareSensor {
  static const MethodChannel _timezoneMethod = const MethodChannel('awareframework_timezone/method');
  // static const EventChannel  _timezoneStream  = const EventChannel('awareframework_timezone/event');

  static const EventChannel  _onTimezoneChangedStream  = const EventChannel('awareframework_timezone/event_on_timezone_changed');

  StreamController<TimezoneData> onTimezoneChangedStreamController = StreamController<TimezoneData>();

  TimezoneData timezone = TimezoneData();

  /// Init Timezone Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = TimezoneSensor.init(null);
  /// ```
  TimezoneSensor():this.init(null);

  /// Init Timezone Sensor with TimezoneSensorConfig
  ///
  /// ```dart
  /// var config =  TimezoneSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = TimezoneSensor.init(config);
  /// ```
  TimezoneSensor.init(TimezoneSensorConfig config) : super(config){
    super.setMethodChannel(_timezoneMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<TimezoneData>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onTimezoneChanged.listen((data) {
  ///   print(data)
  /// }
  Stream<TimezoneData> get onTimezoneChanged {
    onTimezoneChangedStreamController.close();
    onTimezoneChangedStreamController = StreamController<TimezoneData>();
    return onTimezoneChangedStreamController.stream;
  }

  @override
  Future<Null> start() {
    super.getBroadcastStream(_onTimezoneChangedStream, "on_timezone_changed").map(
            (dynamic event) => TimezoneData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      timezone = event;
      if(!onTimezoneChangedStreamController.isClosed){
        onTimezoneChangedStreamController.add(event);
      }
    });
    return super.start();
  }

  @override
  Future<Null> stop(){
    super.cancelBroadcastStream("on_timezone_changed");
    return super.stop();
  }
}

/// A configuration class of TimezoneSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  TimezoneSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class TimezoneSensorConfig extends AwareSensorConfig{

  TimezoneSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}


/// A data model of TimezoneSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class TimezoneData extends AwareData {

  String timezoneId = "";

  TimezoneData():this.from(null);
  TimezoneData.from(Map<String,dynamic> data):super.from(data){
    timezoneId = ["timezoneId"] ?? "";
  }

}

///
/// A Card Widget of Timezone Sensor
///
/// You can generate a Cart Widget by following code.
/// ```dart
/// var card = TimezoneCard(sensor: sensor);
/// ```
class TimezoneCard extends StatefulWidget {
  TimezoneCard({Key key, @required this.sensor}) : super(key: key);

  final TimezoneSensor sensor;

  @override
  TimezoneCardState createState() => new TimezoneCardState();
}

///
/// A Card State of Timezone Sensor
///
class TimezoneCardState extends State<TimezoneCard> {

  String tzInfo = "Current Timezone: ";

  @override
  void initState() {
    super.initState();
    if(mounted) {
      setState(() {
        tzInfo = "Current Timezone: ${widget.sensor.timezone}";
      });
    }
    // set observer
    widget.sensor.onTimezoneChanged.listen((event) {
      if(event!=null){
        if(mounted){
          setState((){
            tzInfo = "Current Timezone: ${event.timezone}";
          });
        }else{
          tzInfo = "Current Timezone: ${event.timezone}";
        }
      }
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text(tzInfo)
        ),
      title: "Timezone",
      sensor: widget.sensor
    );
  }
}
