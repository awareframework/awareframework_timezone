import Flutter
import UIKit
import com_awareframework_ios_sensor_timezone
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkTimezonePlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, TimezoneObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.timezoneSensor = TimezoneSensor.init(TimezoneSensor.Config(config))
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
    
        super.setMethodChannel(with: registrar,
                               instance: instance,
                               channelName: "awareframework_timezone/method")
        super.setEventChannels(with: registrar,
                               instance: instance,
                               channelNames: ["awareframework_timezone/event",
                                              "awareframework_timezone/event_on_timezone_changed"])
    }

    public func onTimezoneChanged(data: TimezoneData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_timezone_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }

}
