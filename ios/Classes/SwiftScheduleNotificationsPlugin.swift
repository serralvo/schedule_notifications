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
    case unschedule = "unscheduleNotifications"
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
            register()
            
            if let content = NotificationContent(withContent: call.arguments as? NSArray) {
                schedule(withTitle: content.title)
            }
            
            result(nil)
        case .unschedule:
            unschedule()
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
        
        var dateComponents = DateComponents()
        // a more realistic example for Gregorian calendar. Every Monday at 11:30AM
        dateComponents.hour = 11
        dateComponents.minute = 30
        dateComponents.second = 0
        dateComponents.weekday = 2
        // starts at sunday, value is 1
        
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
    
    private func unschedule() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["schedule"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["schedule"])
    }
    
}

class NotificationContent {
    
    let title: String
    let when: String
    var repeatAt: [Int] = []
    
    init?(withContent content: NSArray?) {
        
        guard let content = content else {
            return nil
        }
        
        if let title = content[0] as? String,
            let whenRaw = content[1] as? String,
            let repeatAtRaw = content[2] as? [Int] {
            self.title = title
            self.when = whenRaw
            self.repeatAt = repeatAtRaw.map({ (weekDayRaw: Int) -> Int in
                if weekDayRaw == 7 {
                    return 1
                } else {
                    return weekDayRaw + 1
                }
            })
        } else {
            return nil
        }
        
    }
}
