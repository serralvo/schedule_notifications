import Flutter
import UIKit
import UserNotifications
    
open class SwiftScheduleNotificationsPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "schedule_notifications", binaryMessenger: registrar.messenger())
    let instance = SwiftScheduleNotificationsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
    

    open func register(_ call: FlutterMethodCall) {
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            } else {
                print("Success!")
            }
        }
        
    }
    
    open func schedule(withTitle title: String) {
        
    }
    
    
}
