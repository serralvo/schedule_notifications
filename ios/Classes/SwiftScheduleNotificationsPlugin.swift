//
//  TextFieldCounter.swift
//  ScheduleNotifications
//
//  Created by Fabricio Serralvo on 3/21/18.
//  Copyright © 2018 Fabricio Serralvo. All rights reserved.
//

import Flutter
import UIKit
import UserNotifications

enum Methods: String {
    case schedule = "scheduleNotification"
    case unschedule = "unscheduleNotification"
}
    
open class SwiftScheduleNotificationsPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "schedule_notifications", binaryMessenger: registrar.messenger())
        let instance = SwiftScheduleNotificationsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    // MARK: Public Methods
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        guard let method = Methods.init(rawValue: call.method) else {
            result(nil)
            return
        }
        
        switch method {
        case .schedule:
            self.register()
            self.schedule(withTitle: "olá")
            result(nil)
        case .unschedule:
            print("TODO :)")
            result(nil)
        }
        
    }
    
    // MARK: Private
    
    private func register() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if !success {
                print("Whoooops")
            } else {
                print("Success!")
            }
        }
        
    }
    
    private func schedule(withTitle title: String) {
        
        let content = UNMutableNotificationContent()
        content.body = title
        
        let date = Date(timeIntervalSinceNow: 5)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: "schedule", content: content, trigger: trigger)
    
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                print("Hell yeah!")
            }
        })
        
    }
    
}
