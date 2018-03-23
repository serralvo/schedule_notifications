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
                schedule(content)
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
    
    private func schedule(_ notification: NotificationContent) {
        
        let content = UNMutableNotificationContent()
        content.body = notification.title
        
        var dateComponents: DateComponents?
        
        if notification.shouldRepeat {
            for day in notification.repeatAt {
                print("Should repeat at \(day)")
            }
            
        } else {
            dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: notification.when)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents!, repeats: notification.shouldRepeat)
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
            let repeatAtRaw = content[2] as? [Int] {
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
