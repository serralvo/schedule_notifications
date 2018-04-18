#import "ScheduleNotificationsPlugin.h"
#import <UserNotifications/UserNotifications.h>
#import "NotificationContent.h"

@implementation ScheduleNotificationsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"schedule_notifications"
            binaryMessenger:[registrar messenger]];
  ScheduleNotificationsPlugin* instance = [[ScheduleNotificationsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

// MARK: Public Methods

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"scheduleNotification" isEqualToString:call.method]) {

      NotificationContent * content = [[NotificationContent alloc] initWithContent:call.arguments];

      if (content != [NSNull class] && content != nil) {
          [self prepareToScheduleWithNotificationContent:content];
      }

      [self prepareToScheduleWithNotificationContent:call.arguments];
  } else if ([@"unscheduleNotifications" isEqualToString:call.method]) {
      [self unschedule];
  } else if ([@"requestAuthorization" isEqualToString:call.method]) {
      [self requestAuthorization];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

// MARK: Private

- (void) prepareToScheduleWithNotificationContent:(NotificationContent *)notification {

    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc] init];
    content.title = notification.title;

    if (notification.repeatAt.count > 0) {
        NSCalendar * calendar = NSCalendar.currentCalendar;
        NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:notification.when];
        NSInteger minute = [calendar component:NSCalendarUnitMinute fromDate:notification.when];

        NSDateComponents * dateComponents = [[NSDateComponents alloc] init];

        for (id rawWeekDay in notification.repeatAt) {

            NSInteger weekDay = (NSInteger)rawWeekDay;

            if (weekDay == 7) {
                weekDay = 1;
            } else {
                weekDay = weekDay + 1;
            }

            dateComponents.hour = hour;
            dateComponents.minute = minute;
            dateComponents.weekday = weekDay;

            UNCalendarNotificationTrigger * trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];
            [self scheduleWithContent:content notificationTrigger:trigger];
        }
    } else {

        NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:notification.when];
        UNCalendarNotificationTrigger * trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
        [self scheduleWithContent:content notificationTrigger:trigger];
    }
}

- (void)requestAuthorization {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) { }];
}

- (void)scheduleWithContent:(UNNotificationContent * _Nonnull) content notificationTrigger:(UNCalendarNotificationTrigger * _Nonnull)trigger {
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:@"schedule" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

- (void)unschedule {
    NSArray * identifiers = [NSArray arrayWithObjects:@"schedule", nil];
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:identifiers];
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:identifiers];
}

@end



