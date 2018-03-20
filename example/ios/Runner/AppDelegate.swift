import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Methods Register
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let scheduleChannel: FlutterMethodChannel = FlutterMethodChannel(name: "schedule", binaryMessenger: controller)
    
    scheduleChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if ("schedule" == call.method) {
            self.receiveBatteryLevel(result: result)
        } else {
            result(FlutterMethodNotImplemented);
        }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // MARK: Private
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current;
        device.isBatteryMonitoringEnabled = true;
        if (device.batteryState == UIDeviceBatteryState.unknown) {
            result(FlutterError.init(code: "UNAVAILABLE",
                                     message: "Battery info unavailable",
                                     details: nil));
        } else {
            result(Int(device.batteryLevel * 100));
        }
    }
    
    
}
