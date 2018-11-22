import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class TimezoneSensor extends AwareSensorCore {
  static const MethodChannel _timezoneMethod = const MethodChannel('awareframework_timezone/method');
  static const EventChannel  _timezoneStream  = const EventChannel('awareframework_timezone/event');

  static const EventChannel  _onTimezoneChangedStream  = const EventChannel('awareframework_timezone/event_on_timezone_changed');

  /// Init Timezone Sensor with TimezoneSensorConfig
  TimezoneSensor(TimezoneSensorConfig config):this.convenience(config);
  TimezoneSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_timezoneMethod, _timezoneStream);
  }

//  /// A sensor observer instance
//  Stream<Map<String,dynamic>> get onDataChanged {
//     return super.receiveBroadcastStream("on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
//  }

/// A sensor observer instance
  Stream<Map<String,dynamic>> get onTimezoneChanged {
     return _onTimezoneChangedStream.receiveBroadcastStream("on_timezone_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class TimezoneSensorConfig extends AwareSensorConfig{
  TimezoneSensorConfig();

  /// TODO

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class TimezoneCard extends StatefulWidget {
  TimezoneCard({Key key, @required this.sensor}) : super(key: key);

  TimezoneSensor sensor;

  @override
  TimezoneCardState createState() => new TimezoneCardState();
}


class TimezoneCardState extends State<TimezoneCard> {

  String _tzInfo = "Current Timezone: ";

  @override
  void initState() {
    super.initState();
    // set observer
    widget.sensor.onTimezoneChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          _tzInfo = "Current Timezone: ${event.toString()}";
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
          child: new Text(_tzInfo)
        ),
      title: "Timezone",
      sensor: widget.sensor
    );
  }

}
