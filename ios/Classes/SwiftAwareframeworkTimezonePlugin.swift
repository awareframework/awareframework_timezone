import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_timezone
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkTimezonePlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, TimezoneObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.timezoneSensor = TimezoneSensor.init(TimezoneSensor.Config(json))
            }else{
                self.timezoneSensor = TimezoneSensor.init(TimezoneSensor.Config())
            }
            self.timezoneSensor?.CONFIG.sensorObserver = self
            return self.timezoneSensor
        }else{
            return nil
        }
    }

    var timezoneSensor:TimezoneSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAwareframeworkTimezonePlugin()
        // add own channel
        super.setChannels(with: registrar,
                          instance: instance,
                          methodChannelName: "awareframework_timezone/method",
                          eventChannelName: "awareframework_timezone/event")

        let onChangeStreamChannel = FlutterEventChannel.init(name: "awareframework_timezone/event_on_timezone_changed", binaryMessenger: registrar.messenger())
        onChangeStreamChannel.setStreamHandler(instance)
    }

    public func onTimezoneChanged(data: TimezoneData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_timezone_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }

}
