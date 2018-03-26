//
//  SwiftScheduleNotificationsPlugin.swift
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
    case requestAuthorization = "requestAuthorization"
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
            if let content = NotificationContent(withContent: call.arguments as? NSArray) {
                schedule(content)
            }
            result(nil)
        case .unschedule:
            unschedule()
            result(nil)
        case .requestAuthorization:
            requestAuthorization()
            result(nil)
        }
        
    }
    
    // MARK: Private
    
    private func requestAuthorization() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if !success {
                print("Whoooops")
            } else {
                print("Success!")
            }
        }
        
    }
    
    private func schedule(_ notification: NotificationContent) {
        
        let content = UNMutableNotificationContent()
        content.body = notification.title
        
        if notification.shouldRepeat {
        
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: notification.when)
            let minute = calendar.component(.minute, from: notification.when)
        
            var dateComponents = DateComponents()
            
            for day in notification.repeatAt {
                dateComponents.hour = hour
                dateComponents.minute = minute
                dateComponents.weekday = day
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                fire(withContent: content, trigger: trigger)
            }
            
        } else {
            
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notification.when)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            fire(withContent: content, trigger: trigger)
        }
    
    }
    
    private func unschedule() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["schedule"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["schedule"])
    }
 
    private func fire(withContent content: UNNotificationContent, trigger: UNCalendarNotificationTrigger) {
        
        let request = UNNotificationRequest(identifier: "schedule", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification has been scheduled.")
            }
        })
        
    }
    
}

class NotificationContent {
    
    let title: String
    let when: Date
    var repeatAt: [Int] = []
    var shouldRepeat: Bool {
        return repeatAt.isEmpty == false
    }
    
    init?(withContent content: NSArray?) {
        
        guard let content = content else {
            return nil
        }
        
        if let title = content[0] as? String,
            let whenRaw = content[1] as? String,
            let date = NotificationContent.date(withRaw: whenRaw),
            let repeatAtRaw = content[2] as? [Int] { // TODO: Check with an empty array
            self.title = title
            self.when = date
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
    
    class func date(withRaw raw: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter.date(from:raw)
    }
}
