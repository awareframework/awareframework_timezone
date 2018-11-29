import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class TimezoneSensor extends AwareSensorCore {
  static const MethodChannel _timezoneMethod = const MethodChannel('awareframework_timezone/method');
  static const EventChannel  _timezoneStream  = const EventChannel('awareframework_timezone/event');

  static const EventChannel  _onTimezoneChangedStream  = const EventChannel('awareframework_timezone/event_on_timezone_changed');

  /// Init Timezone Sensor with TimezoneSensorConfig
  TimezoneSensor(TimezoneSensorConfig config):this.convenience(config);
  TimezoneSensor.convenience(config) : super(config){
    super.setMethodChannel(_timezoneMethod);
  }

/// A sensor observer instance
  Stream<Map<String,dynamic>> get onTimezoneChanged {
     return super.getBroadcastStream(_onTimezoneChangedStream, "on_timezone_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_timezone_changed");
  }
}

class TimezoneSensorConfig extends AwareSensorConfig{

  TimezoneSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class TimezoneCard extends StatefulWidget {
  TimezoneCard({Key key, @required this.sensor}) : super(key: key);

  final TimezoneSensor sensor;

  String tzInfo = "Current Timezone: ";

  @override
  TimezoneCardState createState() => new TimezoneCardState();
}


class TimezoneCardState extends State<TimezoneCard> {

  @override
  void initState() {
    super.initState();
    // set observer
    widget.sensor.onTimezoneChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          widget.tzInfo = "Current Timezone: ${event["timezoneId"]}";
        }
      });
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
          child: new Text(widget.tzInfo)
        ),
      title: "Timezone",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}
